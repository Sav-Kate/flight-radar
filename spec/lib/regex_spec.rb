require 'rails_helper'

RSpec.describe Regex do
    describe "valid_flight_number" do
        it "returns flight_number valid pattern" do
            expect(described_class.valid_flight_number).to eq(/\A[A-Z0-9]{2,3}[0-9]{1,4}\z/)
        end
    end

    describe "valid_iata" do
        it "returns iata valid pattern" do
            expect(described_class.valid_iata).to eq(/\A[A-Z]{3}\z/)
        end
    end
end