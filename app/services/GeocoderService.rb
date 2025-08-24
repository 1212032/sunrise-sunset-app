class GeocoderService
  def self.coordinates_for(location)
    result = Geocoder.search(location).first
    
    return {
      latitude: result.latitude,
      longitude: result.longitude,
      city: result.city,
      suburb: result.suburb,
      town: result.town,
      country: result.country,
    } if result

    nil
  end
end