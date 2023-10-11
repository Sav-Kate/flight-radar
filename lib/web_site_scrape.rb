class WebSiteScrape
    WEB_SITE_ADDRESS = "https://www.radarbox.com"

    def parse_information_from_website(flight_numbers)
        begin
            @driver = create_driver

            open_flight_radar_website
            check_if_flight_numbers_exist(flight_numbers)
            existing_flight_number = existing_flight_number(flight_numbers)
            open_flight_page

            flight_page_document = Nokogiri::HTML(@driver.page_source)

            flight_distance = flight_page_document
                                            .css("#flight-info")
                                            .css("#content > div:nth-child(3)")
                                            .css("#value").text.gsub("NM", "").strip
            departure_city = airport_city_info(flight_page_document, "origin")
            arrival_city = airport_city_info(flight_page_document, "destination")

            departure_airport_link = airport_page_link(flight_page_document, "origin")
            arrival_airport_link = airport_page_link(flight_page_document, "destination")

            departure_airport_data = airport_info_parse(departure_airport_link)
            arrival_airport_data = airport_info_parse(arrival_airport_link)

            departure_airport_data[:city] = departure_city
            arrival_airport_data[:city] = arrival_city

            if is_flight_multi_leg?
                #TODO: multi leg
                # response_data = {
                #     route:
                #     [
                #         {
                #             departure: "",
                #             arrival: ""
                #         }
                #     ],
                #         status: "",
                #         distance: "",
                #         error_message: ""
                # }
            else
                response_data = {
                    route: 
                    {
                        departure: departure_airport_data,
                        arrival: arrival_airport_data
                    },
                    status: "OK",
                    used_flight_number: existing_flight_number,
                    distance: convert_distance_to_km(flight_distance),
                    error_message: nil
                }
            end
        rescue => exception
            response_data = {
                route: nil,
                status: "FAIL",
                used_flight_number: flight_numbers.size > 1 ? flight_numbers :  flight_numbers[0],
                distance: 0,
                error_message: exception.message
            }
        ensure
            @driver.quit                
        end
        response_data   
    end

    private

    def open_flight_radar_website
        @driver.navigate.to(request_link)
    end

    def existing_flight_number(flight_numbers)
        @driver.find_element(:xpath, '//*[@id="search"]').click

        flight_numbers.each do |flight_number|
            @driver.find_element(:xpath, '//*[@id="input-container"]/input').send_keys(flight_number)
            sleep 3
            if is_element_present?('//*[@id="content"]/ul/div/ul/li')# && !is_element_present?("//*[text()='STATUS N/A']")
                return flight_number
            end
        end
        

        raise "There are no flights with the provided flight number"
    end

    def open_flight_page
        @driver.find_element(:xpath, '//*[@id="content"]/ul/div/ul/li').click
        flight_page_link = @driver.find_element(:xpath, "//*[text()='Flight Page']").attribute("href")
        @driver.navigate.to(flight_page_link)
    end

    def airport_info_parse(page_to_scrape)
        response = HTTParty.get(request_link(page_to_scrape), headers) 
        airport_page_document = Nokogiri::HTML(response.body) 

        airport_country = airport_page_document.css("#location").css("h2").text
        airport_info = JSON[airport_page_document.at('script[type="application/ld+json"]').text]
        airport_iata = airport_info["iataCode"]
        airport_latitude = airport_info["geo"]["latitude"].to_f.round(2)
        airport_longitude = airport_info["geo"]["longitude"].to_f.round(2)
        
        {
            iata: airport_iata,
            country: airport_country,
            latitude: airport_latitude,
            longitude: airport_longitude
        }
    end

    def request_link(custom_part="")
        WEB_SITE_ADDRESS + custom_part
    end

    def headers
        {headers: { 
            "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
        }}
    end

    def airport_city_info(document, destination_type)
        document
        .css("#header-desktop")
        .css("#bottom")
        .css("#airports")
        .css("##{destination_type}")
        .css("a")
        .css("#city")
        .text
    end

    def airport_page_link(document, destination_type)
        document
        .css("#header-desktop")
        .css("#bottom")
        .css("#airports")
        .css("##{destination_type}")
        .css("a")
        .first
        .attribute("href")
        .value
    end

    def create_driver
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("--headless")

        Selenium::WebDriver.for :chrome, options: options
    end

    def is_element_present?(xpath)
        @driver.find_elements(:xpath, xpath).size() > 0 ? true : false
    end

    def check_if_flight_numbers_exist(flight_numbers)
        raise "Invalid flight number" if flight_numbers.empty?
    end

    def convert_distance_to_km(distance)
        (distance.to_f * 1.852).round(2)
    end

    def is_flight_multi_leg?
        #TODO: multi leg
        false
    end
end