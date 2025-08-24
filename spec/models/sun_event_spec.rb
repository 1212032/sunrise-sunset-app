require 'rails_helper'

RSpec.describe SunEvent, type: :model do
  describe "validations" do
    it "is valid with latitude, longitude, and location" do
      event = SunEvent.new(latitude: 40.0, longitude: -8.0, location: "Coimbra")
      expect(event).to be_valid
    end

    it "is invalid without latitude" do
      event = SunEvent.new(latitude: nil, longitude: -8.0, location: "Coimbra")
      expect(event).not_to be_valid
      expect(event.errors[:latitude]).to include("can't be blank")
    end

    it "is invalid without longitude" do
      event = SunEvent.new(latitude: 40.0, longitude: nil, location: "Coimbra")
      expect(event).not_to be_valid
      expect(event.errors[:longitude]).to include("can't be blank")
    end

    it "is invalid without location" do
      event = SunEvent.new(latitude: 40.0, longitude: -8.0, location: nil)
      expect(event).not_to be_valid
      expect(event.errors[:location]).to include("can't be blank")
    end
    
  end
end
