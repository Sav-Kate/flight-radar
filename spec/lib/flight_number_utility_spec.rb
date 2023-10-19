require 'rails_helper'

RSpec.describe FlightNumberUtility do
    describe "check_valid_flight_numbers" do
        context "when provided flight_number is valid" do
            let(:flight_number) { "TEC123" }
            let(:expected_response) do
                {
                    valid_flight_numbers: [flight_number],
                    origin_flight_number: flight_number
                }
            end

            it "returns provided_flight number in valid and origin fields" do
                expect(described_class.new.check_valid_flight_numbers(flight_number)).to eq(expected_response) 
            end
        end

        context "when provided flight_number is not valid" do
            context "when it is possible to create valid flight_numbers" do
                let(:flight_number) { "TEC23e" }
                let(:expected_response) do
                    {
                        valid_flight_numbers: ["TEC23", "TE0C23", "TEC0023"],
                        origin_flight_number: flight_number
                    }
                end

                it "returns array of valid_flight_numbers and origin_flight_number" do
                    expect(described_class.new.check_valid_flight_numbers(flight_number)).to eq(expected_response)
                end
            end

            context "when it is impossible to create valid flight_numbers" do
                let(:flight_number) { "TECd1" }
                let(:expected_response) do
                    {
                        valid_flight_numbers: [],
                        origin_flight_number: flight_number
                    }
                end

                it "returns empty array of valid_flight_numbers and origin_flight_number" do
                    expect(described_class.new.check_valid_flight_numbers(flight_number)).to eq(expected_response)
                end
            end
        end
    end
end