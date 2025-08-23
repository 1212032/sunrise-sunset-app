class GeocoderService
  def self.coordinates_for(location)
    result = Geocoder.search(location).first
    
    return {
      latitude: result.latitude,
      longitude: result.longitude
    } if result

    nil
  end
end