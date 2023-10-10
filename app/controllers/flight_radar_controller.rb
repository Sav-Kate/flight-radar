class FlightRadarController < ApplicationController
  def flight_route
    flight_number = params[:flight_number]
    flight = find_flight_in_db(flight_number)

    if flight
      response = FlightResponseBuilder.build_flight_information(flight)
    else
      response = find_flight_by_scrape(flight_number)

      unless response[:error_message]
        flight = Flight.create!(number: flight_number, distance: response[:distance])
        FlightLegAndAirportCreator.call!(response[:route], flight)
      end  
    end

    render json: response
  end

  private

  def find_flight_in_db(flight_number)
    flight = Flight.where(number: flight_number).includes(:flight_legs, :departure_airports, :arrival_airports).first
  end

  def find_flight_by_scrape(flight_number)
    web_scrape = WebSiteScrape.new

    web_scrape.parse_information_from_website(flight_number)
  end
end
