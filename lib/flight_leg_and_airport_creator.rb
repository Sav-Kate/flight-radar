class FlightLegAndAirportCreator
    def self.call!(route, flight)
        if is_route_multi_leg?(route)
            route.each do |route_info|
                create_airport_and_flight_leg(route_info, flight)
            end
        else
            create_airport_and_flight_leg(route, flight)
        end
    end

    def self.is_route_multi_leg?(route)
        return route.kind_of?(Array) ? true : false
    end

    def self.create_airport_and_flight_leg(route, flight)
        departure_airport = Airport.find_or_create_airport!(route[:departure])
        arrival_airport = Airport.find_or_create_airport!(route[:arrival])

        flight.flight_legs.create(departure_airport: departure_airport, arrival_airport: arrival_airport)
    end

    private_class_method :is_route_multi_leg?, :create_airport_and_flight_leg
end