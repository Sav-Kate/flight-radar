class Airport < ApplicationRecord
    has_many :departure_flight_legs, :class_name => 'FlightLeg', :foreign_key => 'departure_airport_id'
    has_many :arrival_flight_legs, :class_name => 'FlightLeg', :foreign_key => 'arrival_airport_id'

    has_many :departure_flights, :through => :departure_flight_legs, :source => 'flight'
    has_many :arrival_flights, :through => :arrival_flight_legs, :source => 'flight'

    def self.find_or_create_airport!(data)
        airport = Airport.find_by(iata: data[:iata]) || Airport.create(data)

        airport
    end
end
