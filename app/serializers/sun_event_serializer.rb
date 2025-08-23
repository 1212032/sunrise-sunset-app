class SunEventSerializer
  include FastJsonapi::ObjectSerializer
  attributes :date, :sunrise, :sunset, :golden_hour, :latitude, :longitude, :day_length, :location
end
