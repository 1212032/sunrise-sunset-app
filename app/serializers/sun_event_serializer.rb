class SunEventSerializer
  include FastJsonapi::ObjectSerializer
  attributes :date, :sunrise, :sunset, :golden_hour, :latitude, :longitude
end
