class FlightRadarController < ApplicationController
  def flight_route
    passed_flight_number = params[:flight_number].upcase
    valid_flight_numbers = FlightNumberUtility.new.valid_flight_numbers(passed_flight_number)
  
    flight = find_flight_in_db(valid_flight_numbers)

    if flight
      response = FlightResponseBuilder.build_flight_information(flight)
    else
      response = find_flight_by_scrape(valid_flight_numbers)

      unless response[:error_message]
        flight = Flight.create!(number: response[:used_flight_number], distance: response[:distance])
        FlightLegAndAirportCreator.call!(response[:route], flight)
      end  
    end

    render json: response
  end

  private

  def find_flight_in_db(flight_numbers)
    flight = nil
    flight_numbers.each do |flight_number|
      flight = Flight.where(number: flight_number).includes(:flight_legs, :departure_airports, :arrival_airports).first
      return flight if flight
    end
    flight
  end

  def find_flight_by_scrape(flight_numbers)
    web_scrape = WebSiteScrape.new

    web_scrape.parse_information_from_website(flight_numbers)
  end
end
