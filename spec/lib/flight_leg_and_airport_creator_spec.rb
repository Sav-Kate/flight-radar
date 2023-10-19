require 'rails_helper'

RSpec.describe FlightLegAndAirportCreator do
    let(:flight) { create(:flight) }
    describe "call!" do
        context "when route is multi_leg" do
            let(:route) do
                [
                    {
                        departure: {iata: "DEP", country: "DepCountry", latitude: 11.3, longitude: 44.3, city: "DepCity"},
                        arrival: {iata: "LAR", country: "ArrCountry", latitude: 44.56, longitude: 54.12, city: "ArrCity"}
                    },
                    {
                        departure: {iata: "LDP", country: "DepCountry", latitude: 11.3, longitude: 44.3, city: "DepCity"},
                        arrival: {iata: "ARR", country: "ArrCountry", latitude: 44.56, longitude: 54.12, city: "ArrCity"}
                    }
                ]
            end

            it "creates several flight_legs" do
                expect { described_class.call!(route, flight) }.to change { FlightLeg.count }.by(2)
            end

            context "when departure_airport and arrival_airport are not already saved" do
                it "creates several departure_airports and arrival_airports" do
                    expect { described_class.call!(route, flight) }.to change { Airport.count }.by(4)
                end
            end

            context "when departure_airports and arrival_airports are already saved" do
                let(:departure_airport) { create(:airport, iata: "DEP") }
                let(:leg_arrival_airport) { create(:airport, iata: "LAR") }
                let(:leg_departure_airport) { create(:airport, iata: "LDP") }
                let(:arrival_airport) { create(:airport, iata: "ARR") }

                it "does not create departure_airport and arrival_airport" do
                    allow(Airport).to receive(:find_or_create_airport!).with(route[0][:departure]).and_return(departure_airport)
                    allow(Airport).to receive(:find_or_create_airport!).with(route[0][:arrival]).and_return(leg_arrival_airport)
                    allow(Airport).to receive(:find_or_create_airport!).with(route[1][:departure]).and_return(leg_departure_airport)
                    allow(Airport).to receive(:find_or_create_airport!).with(route[1][:arrival]).and_return(arrival_airport)
                    expect { described_class.call!(route, flight) }.to change { Airport.count }.by(0)
                end
            end
        end

        context "when route is not multi_leg" do
            let(:route) do
                {
                    departure: {iata: "DEP", country: "DepCountry", latitude: 11.3, longitude: 44.3, city: "DepCity"},
                    arrival: {iata: "ARR", country: "ArrCountry", latitude: 44.56, longitude: 54.12, city: "ArrCity"}
                }
            end

            it "creates flight_leg" do
                expect { described_class.call!(route, flight) }.to change { FlightLeg.count }.by(1)
            end

            context "when departure_airport and arrival_airport are not already saved" do
                it "creates departure_airport and arrival_airport" do
                    expect { described_class.call!(route, flight) }.to change { Airport.count }.by(2)
                end
            end

            context "when departure_airport and arrival_airport are already saved" do
                let(:departure_airport) { create(:airport, iata: "DEP") }
                let(:arrival_airport) { create(:airport, iata: "ARR") }

                it "does not create departure_airport and arrival_airport" do
                    allow(Airport).to receive(:find_or_create_airport!).with(route[:departure]).and_return(departure_airport)
                    allow(Airport).to receive(:find_or_create_airport!).with(route[:arrival]).and_return(arrival_airport)
                    expect { described_class.call!(route, flight) }.to change { Airport.count }.by(0)
                end
            end
        end
    end
end