class SunEvent < ApplicationRecord
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :location, presence: true

    def self.find_by_location_and_date_range(lat, lng, start_date, end_date)
        where(latitude: lat, longitude: lng)
            .where(date: start_date..end_date)
            .order(:date)
    end
end
