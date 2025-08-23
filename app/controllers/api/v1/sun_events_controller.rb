module Api
  module V1
    class SunEventsController < ApplicationController
      before_action :validate_params

      def index
        location = params[:location]
        start_date = params[:start_date]
        end_date = params[:end_date]

        if location.blank? || start_date.blank? || end_date.blank?
          return render json: { error: "Missing parameters: location, start_date, end_date" }, status: :bad_request
        end
        
        coordinates = GeocoderService.coordinates_for(location)
        if coordinates.nil?
          return render json: { error: "Invalid location" }, status: :bad_request
        end

        latitude = coordinates[:latitude]
        longitude = coordinates[:longitude]
        location = format_location(coordinates)

        puts "=== DEBUG: Geocoder coordinates ==="
        puts "Latitude: #{latitude}"
        puts "Longitude: #{longitude}"

        # Check if already cached in DB
        cached_events = SunEvent.find_by_location_and_date_range(latitude, longitude, start_date, end_date)
        
        puts "=== DEBUG: Cached events found ==="
        puts "Number of cached events: #{cached_events.size}"
        puts "Expected number: #{(Date.parse(end_date) - Date.parse(start_date) + 1).to_i}"

        # Find missing dates
        all_dates = (Date.parse(start_date)..Date.parse(end_date)).to_a
        cached_dates = cached_events.map(&:date)
        missing_dates = all_dates - cached_dates

        puts "=== DEBUG: Missing dates ==="
        puts "Missing dates: #{missing_dates.map(&:to_s)}"
        puts "Missing count: #{missing_dates.size}"

        # If all dates are cached, return them
        if missing_dates.empty?
          puts "=== DEBUG: All data cached, returning from DB ==="
          return render json: SunEventSerializer.new(cached_events).serializable_hash
        end

        # Fetch only missing dates from API
        begin
          puts "=== DEBUG: Fetching missing dates from API ==="
          new_events = fetch_and_save_missing_dates(location, latitude, longitude, missing_dates)
          
          # Combine cached events with new events
          all_events = SunEvent.find_by_location_and_date_range(latitude, longitude, start_date, end_date)
          
          render json: SunEventSerializer.new(all_events).serializable_hash
        rescue => e
          render json: { error: "Failed to fetch data: #{e.message}" }, status: :internal_server_error
        end
      end

      private

      def validate_params
        if params[:location].blank? || params[:start_date].blank? || params[:end_date].blank?
          render json: { error: "Missing parameters: location, start_date, end_date" }, status: :bad_request
          return
        end

        begin
          Date.parse(params[:start_date])
          Date.parse(params[:end_date])
        rescue ArgumentError
          render json: { error: "Invalid date format. Use YYYY-MM-DD" }, status: :bad_request
        end
      end
      
      def format_location(coordinates)
        city = coordinates[:city]
        country = coordinates[:country]
        
        if city && country
          "#{city}, #{country}"
        elsif country
          country
        elsif city
          city
        else
          # Fallback to the first part of the address
          coordinates[:address].split(',').first rescue "Unknown location"
        end
      end

      def fetch_and_save_missing_dates(location, latitude, longitude, missing_dates)
        return [] if missing_dates.empty?

        # Se só falta uma data, pede apenas essa data
        if missing_dates.size == 1
          single_date = missing_dates.first
          service = SunEventService.new(latitude, longitude, single_date.to_s, single_date.to_s)
        else
          # Se faltam várias datas, pede o range completo
          start_date = missing_dates.min.to_s
          end_date = missing_dates.max.to_s
          service = SunEventService.new(latitude, longitude, start_date, end_date)
        end

        api_data = service.fetch
        return [] unless api_data.is_a?(Array)

        api_data.map do |event_data|
          # Só guarda se for uma das datas que faltam
          next unless missing_dates.include?(Date.parse(event_data[:date]))

          SunEvent.find_or_create_by(
            latitude: latitude,
            longitude: longitude,
            date: event_data[:date]
          ) do |event|
            event.location = location
            event.sunrise = event_data[:sunrise]
            event.sunset = event_data[:sunset]
            event.first_light = event_data[:first_light]
            event.last_light = event_data[:last_light]
            event.dawn = event_data[:dawn]
            event.dusk = event_data[:dusk]
            event.solar_noon = event_data[:solar_noon]
            event.golden_hour = event_data[:golden_hour]
            event.day_length = event_data[:day_length]
            event.timezone = event_data[:timezone]
            event.utc_offset = event_data[:utc_offset]
          end
        end.compact # Remove nils do 'next unless'
      end
    end
  end
end