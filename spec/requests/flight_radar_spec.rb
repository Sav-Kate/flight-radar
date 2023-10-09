require 'rails_helper'

RSpec.describe "FlightRadars", type: :request do
  describe "GET /flight_route" do
    it "returns http success" do
      get "/flight_radar/flight_route"
      expect(response).to have_http_status(:success)
    end
  end

end
