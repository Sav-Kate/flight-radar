require 'rails_helper'

RSpec.describe "FlightRadars", type: :request do
  describe "GET /flight_route" do
    context "when flight is found" do
      let(:flight) { create(:flight) }
      let(:departure_airport) { create(:airport, iata: "DEP") }
      let(:arrival_airport) { create(:airport, iata: "ARR") }
      let(:flight_leg) { create(:flight_leg, flight: flight, departure_airport: departure_airport, arrival_airport: arrival_airport) }
      let(:expected_response) do
        {
          "route"=>
          {
            "departure"=>{"iata"=>"DEP", "city"=>"City", "country"=>"Country", "latitude"=>12.34, "longitude"=>23.56},
            "arrival"=>{"iata"=>"ARR", "city"=>"City", "country"=>"Country", "latitude"=>12.34, "longitude"=>23.56}
          },
          "status"=>"OK",
          "used_flight_number"=>"ABC123",
          "distance"=>123,
          "error_message"=>nil
        } 
      end

      it "returns response with route information" do
        flight.flight_legs = [flight_leg]
        get "/flight_route/#{flight.number}"
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(expected_response)
      end
    end

    context "when flight is not found" do
      context "when flight number is invald" do
        let(:expected_response) do
          {
            "route"=>nil,
            "status"=>"FAIL",
            "used_flight_number"=>"HHHH123",
            "distance"=>0,
            "error_message"=>"Invalid flight number"
          }
        end

        it "returns response with appropriate error_message" do
          get "/flight_route/HHHh123"
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq(expected_response)
        end
      end

      context "when flight number is valid" do
        let(:scraper) { double(WebSiteScrape) }
        let(:passed_flight_numbers) do
          {
            origin_flight_number: "", 
            valid_flight_numbers: [""]
          }
        end

        before(:each) do
          allow(WebSiteScrape).to receive(:new).and_return(scraper)
        end

        context "when flight number is not found" do
          let(:flight_number) { "HHH123" }
          let(:expected_response) do
            {
              "route"=>nil,
              "status"=>"FAIL",
              "used_flight_number"=>flight_number,
              "distance"=>0,
              "error_message"=>"There are no flights with the provided flight number"
            }
          end
  
          it "returns response with error_message" do
            passed_flight_numbers[:origin_flight_number] = flight_number
            passed_flight_numbers[:valid_flight_numbers] = [flight_number]
            allow(scraper).to receive(:parse_information_from_website).with(passed_flight_numbers).and_return(expected_response)
  
            get "/flight_route/#{flight_number}"
            parsed_response = JSON.parse(response.body)
            expect(parsed_response).to eq(expected_response)
          end
        end

        context "when flight number is found" do
          let(:flight_number) { "DY140" }
          let(:expected_response) do
            {
              "route"=>
              {
                "departure"=>{"iata"=>"DEP", "city"=>"City", "country"=>"Country", "latitude"=>12.34, "longitude"=>23.56},
                "arrival"=>{"iata"=>"ARR", "city"=>"City", "country"=>"Country", "latitude"=>12.34, "longitude"=>23.56}
              },
              "status"=>"OK",
              "used_flight_number"=>flight_number,
              "distance"=>123,
              "error_message"=>nil
            } 
          end
    
          it "returns response with route information" do
            passed_flight_numbers[:origin_flight_number] = flight_number
            passed_flight_numbers[:valid_flight_numbers] = [flight_number]
            allow(scraper).to receive(:parse_information_from_website).with(passed_flight_numbers).and_return(expected_response)

            get "/flight_route/#{flight_number}"
            parsed_response = JSON.parse(response.body)
            expect(parsed_response).to eq(expected_response)
          end 
        end
      end
    end
  end
end
