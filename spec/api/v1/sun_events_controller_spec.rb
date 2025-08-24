# spec/controllers/api/v1/sun_events_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::SunEventsController, type: :controller do
  describe "GET #index" do
    let(:latitude) { 40.2111 }
    let(:longitude) { -8.4292 }
    let(:location) { "Coimbra" }
    let(:start_date) { "2025-08-24" }
    let(:end_date) { "2025-08-25" }

    before do
      # Mock GeocoderService
      allow(GeocoderService).to receive(:coordinates_for).with(location).and_return(
        { latitude: latitude, longitude: longitude, city: "Coimbra", country: "Portugal" }
      )
    end

    context "when parameters are missing" do
      it "returns bad_request if location is missing" do
        get :index, params: { start_date: start_date, end_date: end_date }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to include("Missing parameters")
      end

      it "returns bad_request if start_date is missing" do
        get :index, params: { location: location, end_date: end_date }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to include("Missing parameters")
      end

      it "returns bad_request if end_date is missing" do
        get :index, params: { location: location, start_date: start_date }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to include("Missing parameters")
      end
    end

    context "when location is invalid" do
      before do
        allow(GeocoderService).to receive(:coordinates_for).with("InvalidCity").and_return(nil)
      end

      it "returns bad_request with invalid location" do
        get :index, params: { location: "InvalidCity", start_date: start_date, end_date: end_date }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid location")
      end
    end

    context "when data is cached in DB" do
      let!(:cached_event) do
        SunEvent.create!(
          latitude: latitude,
          longitude: longitude,
          date: Date.parse(start_date),
          location: "Coimbra, Portugal",
          sunrise: "06:30",
          sunset: "20:15"
        )
      end

      it "returns cached events without calling the API service" do
        expect_any_instance_of(SunEventService).not_to receive(:fetch)

        get :index, params: { location: location, start_date: start_date, end_date: start_date }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"].first["attributes"]["sunrise"]).to eq("06:30")
      end
    end

    context "when some dates are missing in DB" do
      before do
        # Simula chamada ao serviço API
        fake_api_response = [
          { date: end_date, sunrise: "06:31", sunset: "20:14", first_light: "06:01", last_light: "20:44",
            dawn: "06:11", dusk: "20:34", solar_noon: "13:15", golden_hour: "19:31", day_length: "13:43",
            timezone: "UTC", utc_offset: 0 }
        ]

        allow_any_instance_of(SunEventService).to receive(:fetch).and_return(fake_api_response)
      end

      it "calls SunEventService for missing dates and returns combined events" do
        # Apenas start_date está no cache
        SunEvent.create!(latitude: latitude, longitude: longitude, date: Date.parse(start_date), location: "Coimbra, Portugal")

        get :index, params: { location: location, start_date: start_date, end_date: end_date }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        dates = body["data"].map { |e| e["attributes"]["date"] }
        expect(dates).to contain_exactly(start_date, end_date)
      end
    end

    context "when SunEventService fails" do
      before do
        allow_any_instance_of(SunEventService).to receive(:fetch).and_raise("API down")
      end

      it "returns internal_server_error" do
        get :index, params: { location: location, start_date: start_date, end_date: end_date }
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)["error"]).to include("Failed to fetch data")
      end
    end
  end
end
