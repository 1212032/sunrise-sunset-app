# spec/services/sun_event_service_spec.rb
require 'rails_helper'
require 'httparty'

RSpec.describe SunEventService do
  let(:latitude) { 40.2111 }
  let(:longitude) { -8.4292 }
  let(:start_date) { "2025-08-24" }
  let(:end_date) { "2025-08-24" }

  describe "#fetch" do
    context "when the API returns a successful response" do
      let(:api_response) do
        {
          "status" => "OK",
          "results" => {
            "date" => start_date,
            "sunrise" => "06:30",
            "sunset" => "20:15",
            "first_light" => "06:00",
            "last_light" => "20:45",
            "dawn" => "06:10",
            "dusk" => "20:35",
            "solar_noon" => "13:15",
            "golden_hour" => "19:30",
            "day_length" => "13:45",
            "timezone" => "UTC",
            "utc_offset" => 0
          }
        }.to_json
      end

      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, body: api_response))
      end

      it "returns an array of sun event hashes" do
        service = SunEventService.new(latitude, longitude, start_date)
        result = service.fetch

        expect(result).to be_an(Array)
        expect(result.first[:date]).to eq(start_date)
        expect(result.first[:sunrise]).to eq("06:30")
        expect(result.first[:sunset]).to eq("20:15")
        expect(result.first[:utc_offset]).to eq(0)
      end
    end

    context "when the API returns an error status" do
      let(:api_response) do
        { "status" => "INVALID_REQUEST" }.to_json
      end

      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, body: api_response))
      end

      it "returns a hash with an error" do
        service = SunEventService.new(latitude, longitude, start_date)
        result = service.fetch

        expect(result).to eq({ error: "INVALID_REQUEST" })
      end
    end

    context "when the HTTP request fails" do
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: false))
      end

      it "returns a hash with a generic error" do
        service = SunEventService.new(latitude, longitude, start_date)
        result = service.fetch

        expect(result).to eq({ error: "API request failed" })
      end
    end

    context "when start_date and end_date are different" do
      let(:end_date) { "2025-08-25" }
      let(:api_response) do
        {
          "status" => "OK",
          "results" => [
            { "date" => start_date, "sunrise" => "06:30", "sunset" => "20:15", "utc_offset" => 0 },
            { "date" => end_date, "sunrise" => "06:31", "sunset" => "20:14", "utc_offset" => 0 }
          ]
        }.to_json
      end

      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, body: api_response))
      end

      it "returns an array with multiple results" do
        service = SunEventService.new(latitude, longitude, start_date, end_date)
        result = service.fetch

        expect(result.size).to eq(2)
        expect(result.map { |r| r[:date] }).to contain_exactly(start_date, end_date)
      end
    end
    context "when given invalid parameters" do
        let(:end_date) { "2025-08-25" }
        let(:api_response) do
            {
            "status" => "API requeste failed"
            }.to_json
        end

        before do
            allow(HTTParty).to receive(:get).and_return(double(success?: false, body: api_response))
        end

        it "returns an error if latitude is nil" do
            service = SunEventService.new(nil, -8.4292, "2025-08-24", "2025-08-25")
            result = service.fetch

            expect(result).to eq({error: "API request failed"})
        end
        it "returns an error if longitude is nil" do
            service = SunEventService.new(40.2111, nil, "2025-08-24","2025-08-24")
            result = service.fetch

            expect(result).to eq({ error: "API request failed" })
        end

        it "returns an error if both latitude and longitude are nil" do
            service = SunEventService.new(nil, nil, "2025-08-24", "2025-08-24")
            result = service.fetch
            
            expect(result).to eq({ error: "API request failed" })
        end
        it "handles invalid date formats graacefully" do
            service = SunEventService.new(40.2111, -8.4292, "invalid-date")
            result = service.fetch
            
            expect(result).to eq({ error: "API request failed" })
        end
    end
  end
end
