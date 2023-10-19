require 'rails_helper'

RSpec.describe FlightResponseBuilder do
    describe "build_flight_information" do
        let(:flight) { create(:flight) }
        let(:departure_airport) { create(:airport, iata: "DEP") }
        let(:arrival_airport) { create(:airport, iata: "ARR") }

        context "when flight is multi_leg" do
            let(:leg_arrival_airport) { create(:airport, iata: "LAR") }
            let(:leg_departure_airport) { create(:airport, iata: "LDP") }
            let(:first_flight_leg) { create(:flight_leg, flight: flight, departure_airport: departure_airport, arrival_airport: leg_arrival_airport) }
            let(:second_flight_leg) { create(:flight_leg, flight: flight, departure_airport: leg_departure_airport, arrival_airport: arrival_airport) }
            let(:expected_response) do
                {
                    route:
                    [
                        {
                            departure: 
                            {
                                iata: departure_airport.iata,
                                city:departure_airport.city,
                                country: departure_airport.country,
                                latitude: departure_airport.latitude,
                                longitude: departure_airport.longitude
                            },
                            arrival: 
                            {
                                iata: leg_arrival_airport.iata,
                                city:leg_arrival_airport.city,
                                country: leg_arrival_airport.country,
                                latitude: leg_arrival_airport.latitude,
                                longitude: leg_arrival_airport.longitude
                            },
                        },
                        {
                            departure: 
                            {
                                iata: leg_departure_airport.iata,
                                city:leg_departure_airport.city,
                                country: leg_departure_airport.country,
                                latitude: leg_departure_airport.latitude,
                                longitude: leg_departure_airport.longitude
                            },
                            arrival:
                            {
                                iata: arrival_airport.iata,
                                city:arrival_airport.city,
                                country: arrival_airport.country,
                                latitude: arrival_airport.latitude,
                                longitude: arrival_airport.longitude
                            },
                        },
                    ],
                    status: "OK",
                    used_flight_number: flight.number,
                    distance: flight.distance,
                    error_message: nil
                }
            end

            before do
                flight.flight_legs << first_flight_leg
                flight.flight_legs << second_flight_leg
            end

            it "returns response with several departure and arrival airports" do
                expect(described_class.build_flight_information(flight)).to eq(expected_response)
            end
        end

        context "when flight is not multi_leg" do
            let(:flight_leg) { create(:flight_leg, flight: flight, departure_airport: departure_airport, arrival_airport: arrival_airport) }
            let(:expected_response) do
                {
                    route: 
                    {
                        departure: 
                        {
                            iata: departure_airport.iata,
                            city:departure_airport.city,
                            country: departure_airport.country,
                            latitude: departure_airport.latitude,
                            longitude: departure_airport.longitude
                        },
                        arrival: {
                            iata: arrival_airport.iata,
                            city:arrival_airport.city,
                            country: arrival_airport.country,
                            latitude: arrival_airport.latitude,
                            longitude: arrival_airport.longitude
                        },
                    },
                    status: "OK",
                    used_flight_number: flight.number,
                    distance: flight.distance,
                    error_message: nil
                }
            end

            before do
                flight.flight_legs << flight_leg
            end

            it "returns response with departure and arrival airports" do
                expect(described_class.build_flight_information(flight)).to eq(expected_response)
            end
        end
    end
end