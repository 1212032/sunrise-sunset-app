# spec/services/geocoder_service_spec.rb
require 'rails_helper'

RSpec.describe GeocoderService do
  describe ".coordinates_for" do
    let(:location) { "Coimbra, Portugal" }

    context "when Geocoder returns a result" do
      let(:geocoder_result) do
        double(
          latitude: 40.2111,
          longitude: -8.4292,
          city: "Coimbra",
          suburb: nil,
          town: nil,
          country: "Portugal"
        )
      end

      before do
        allow(Geocoder).to receive(:search).with(location).and_return([ geocoder_result ])
      end

      it "returns a hash with latitude, longitude, city, and country" do
        result = GeocoderService.coordinates_for(location)

        expect(result).to eq({
          latitude: 40.2111,
          longitude: -8.4292,
          city: "Coimbra",
          suburb: nil,
          town: nil,
          country: "Portugal"
        })
      end
    end

    context "when Geocoder returns nil" do
      before do
        allow(Geocoder).to receive(:search).with(location).and_return([])
      end

      it "returns nil" do
        expect(GeocoderService.coordinates_for(location)).to be_nil
      end
    end

    context "when suburb is missing but city or town is present" do
      let(:geocoder_result) do
        double(
          latitude: 40.0,
          longitude: -8.0,
          city: "Porto",
          suburb: nil,
          town: nil,
          country: "Portugal"
        )
      end

      before do
        allow(Geocoder).to receive(:search).with(location).and_return([ geocoder_result ])
      end

      it "uses suburb as city" do
        result = GeocoderService.coordinates_for(location)
        expect(result[:city]).to eq("Porto")
      end
    end
  end
end
