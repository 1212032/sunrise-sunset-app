class SunEventService
  BASE_URL = 'https://api.sunrisesunset.io/json'.freeze
  
  def initialize(latitude, longitude, start_date = nil, end_date = nil)
    @latitude = latitude
    @longitude = longitude
    @start_date = start_date
    @end_date = end_date
  end

  def fetch
    params = {
      lat: @latitude,
      lng: @longitude,
      timezone: 'UTC',
      time_format: '24'
    }

    # Adiciona parâmetros de data conforme necessário
    if @start_date && @end_date && @start_date != @end_date
      params[:date_start] = @start_date
      params[:date_end] = @end_date
    elsif @start_date
      params[:date] = @start_date
    end

    puts "=== DEBUG: API Request ==="
    puts "Params: #{params}"

    response = HTTParty.get(BASE_URL, query: params)
    return { error: "API request failed" } unless response.success?

    parse_response(response)
  end

  private

  def parse_response(response)
    data = JSON.parse(response.body)
    
    if data['status'] == 'OK'
      results = data['results'].is_a?(Array) ? data['results'] : [data['results']]
      results.map { |result| transform_result(result) }
    else
      { error: data['status'] }
    end
  end

  def transform_result(result)
    {
      date: result['date'],
      sunrise: result['sunrise'],
      sunset: result['sunset'],
      first_light: result['first_light'],
      last_light: result['last_light'],
      dawn: result['dawn'],
      dusk: result['dusk'],
      solar_noon: result['solar_noon'],
      golden_hour: result['golden_hour'],
      day_length: result['day_length'],
      timezone: result['timezone'],
      utc_offset: result['utc_offset']
    }
  end
end