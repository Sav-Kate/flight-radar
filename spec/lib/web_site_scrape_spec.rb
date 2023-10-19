require 'rails_helper'

RSpec.describe WebSiteScrape do
    describe "parse_information_from_website" do
        let(:passed_flight_numbers) do
            {
                valid_flight_numbers: "",
                origin_flight_number: ""
            }
        end
        let(:options) { double(Selenium::WebDriver::Chrome::Options) }
        let(:driver) { double(Selenium::WebDriver, browser: :chrome, options: options) }
        let(:element) { double(Selenium::WebDriver::Element) }
        context "when flight_numbers exist" do
            context "when there are no flights with the provided flight number" do
                let(:expected_response) do
                    {
                        route: nil,
                        status: "FAIL",
                        used_flight_number: passed_flight_numbers[:origin_flight_number],
                        distance: 0,
                        error_message: "There are no flights with the provided flight number"
                    }
                end

                it "return respons with appropriate error_message" do
                    passed_flight_numbers[:valid_flight_numbers] = ["QQQ1"]
                    passed_flight_numbers[:origin_flight_number] = "QQQ1"

                    create_driver
                    open_flight_radar_website
                    open_search_element
                    receive_input_element
                    enter_flight_number(passed_flight_numbers[:origin_flight_number])
                    allow(driver).to receive(:find_elements).with(:xpath, '//*[@id="content"]/ul/div/ul/li').and_return([])
                    quit_driver

                    expect(described_class.new.parse_information_from_website(passed_flight_numbers)).to eq(expected_response)
                end 
            end

            context "when there are flights with the provided flight number" do
                let(:expected_response) do
                    {
                        route: 
                        {
                            departure: {
                                iata: "LHR",
                                city: "London Heathrow",
                                country: "United Kingdom",
                                latitude: 51.47,
                                longitude: -0.46
                            },
                            arrival: {
                                iata: "CPH",
                                city: "Copenhagen",
                                country: "Denmark",
                                latitude: 55.62,
                                longitude: 12.66
                            }
                        },
                        status: "OK",
                        used_flight_number: passed_flight_numbers[:origin_flight_number],
                        distance: 979.71,
                        error_message: nil
                    }
                end

                it "returns response with appropriate information" do
                    passed_flight_numbers[:valid_flight_numbers] = ["BA812"]
                    passed_flight_numbers[:origin_flight_number] = "BA812"
                    expect(described_class.new.parse_information_from_website(passed_flight_numbers)).to eq(expected_response)
                end
            end
        end

        context "when flight_numbers not exist" do
            let(:expected_response) do
                {
                    route: nil,
                    status: "FAIL",
                    used_flight_number: passed_flight_numbers[:origin_flight_number],
                    distance: 0,
                    error_message: "Invalid flight number"
                }
            end
            it "return response with appropriate error_message" do
                passed_flight_numbers[:valid_flight_numbers] = []
                passed_flight_numbers[:origin_flight_number] = "TECd1"
                expect(described_class.new.parse_information_from_website(passed_flight_numbers)).to eq(expected_response)
            end
        end
    end
    def create_driver
        allow(Selenium::WebDriver::Chrome::Options).to receive(:new).and_return(options)
        allow(options).to receive(:add_argument).with("--headless").and_return(options)
        allow(Selenium::WebDriver).to receive(:for).with(:chrome, options: options).and_return(driver)
      end
    
      def open_flight_radar_website
        allow(driver).to receive(:navigate).and_return(driver)
        allow(driver).to receive(:to).with("https://www.radarbox.com")
      end
    
      def open_search_element
        allow(driver).to receive(:find_elements).with(:xpath, '//*[@id="input-container"]/input').and_return(element)
        allow(element).to receive(:size).and_return(1)
        allow(driver).to receive(:find_element).with(:xpath, '//*[@id="search"]').and_return(element)
        allow(element).to receive(:click).and_return(element)
      end
    
      def receive_input_element
        allow(driver).to receive(:find_element).with(:xpath, '//*[@id="input-container"]/input').and_return(element)
      end
    
      def enter_flight_number(flight_number)
        allow(element).to receive(:send_keys).with(flight_number)
      end
    
      def quit_driver
        allow(driver).to receive(:quit)
      end
    
      def open_flight_page
        allow(driver).to receive(:find_element).with(:xpath, '//*[@id="content"]/ul/div/ul/li').and_return(element)
        allow(element).to receive(:click).and_return(element)
        allow(driver).to receive(:find_element).with(:xpath, "//*[text()='Flight Page']").and_return(element)
        allow(element).to receive(:attribute).with("href").and_return("")
        allow(driver).to receive(:navigate).and_return(driver)
        allow(driver).to receive(:to).with("")
      end
end