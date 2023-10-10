class FlightResponseBuilder
    def self.build_flight_information(flight)
        response = 
        {
            route: build_route_info(flight.flight_legs),
            status: "OK",
            distance: flight.distance,
            error_message: nil
        }

        response
    end

    def self.build_route_info(flight_legs, flight)
        response = []
        if flight.is_flight_multi_leg?
            flight_legs.each do |flight_leg|
                info = {
                    departure: build_airport_info(flight_leg.departure_airport),
                    arrival: build_airport_info(flight_leg.arrival_airport)
                }
                response << info
            end
        else
            response = {
                departure: build_airport_info(flight_legs.first.departure_airport),
                arrival: build_airport_info(flight_legs.first.arrival_airport)
            }
        end
        response
    end

    def self.build_airport_info(airport)        
        {
            iata: airport.iata,
            city: airport.city,
            country: airport.country,
            latitude: airport.latitude,
            longitude: airport.longitude
        }
    end

    private_class_method :build_route_info, :build_airport_info
end