require 'uri'
require 'json'
require 'net/http'
require 'net/https'

module Kakaxi
  class Client
    COMMON_HEADER = { 'Content-Type' => 'application/json' }
    BASE_URL = 'https://kakaxi-data.me/api/v1/'
    attr_reader :current_device, :temps, :temp_data, :token,
                :farm, :devices, :humidities, :timelapses, :solar_radiations,
                :rainfalls, :interval_photos, :interval_photo_data

    def initialize(email, password)
      @email = email
      @password = password
      @token = get_token
      @farm = get_farm
      @devices = get_devices
      @current_device = @devices[0]
    end

    def set_current_device(index: 0, id: nil, name: nil)
      @current_device = @devices[index] if id.nil? && name.nil?
      @current_device = @devices.find { |device| device.id == id } unless id.nil?
      @current_device = @devices.find { |device| device.name == name } unless name.nil?
    end

    def load_temps(days: 5, unit: 'celsius')
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{current_device.id}/indicators/temperature?days=#{days}&unit=#{unit}")
      temps = get(uri)['data']
      Struct.new('TempMetaData', :size, :unit, :device_id)
      @temps = temps.map do |temp|
        Kakaxi::Data::Temperature.new(value: temp['temperature'], recorded_at: temp['recorded_at'], interpolation: temp['interpolation'])
      end
      @temp_data = Struct::TempMetaData.new(@temps.length, unit, @current_device.id)
    end

    def load_humidities(days: 5)
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{current_device.id}/indicators/humidity?days=#{days}")
      humidities = get(uri)['data']
      Struct.new('HumidityMetaData', :size, :device_id)
      @humidities = humidities.map do |humidity|
        Kakaxi::Data::Humidity.new(
          value: humidity['humidity'],
          recorded_at: humidity['recorded_at'],
          interpolation: humidity['interpolation'],
          deficit: humidity['humidity_deficit']
        )
      end
      @humidity_data = Struct::HumidityMetaData.new(@humidities.length, @current_device.id)
    end

    def load_solar_radiations(days: 5)
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{@current_device.id}/indicators/solar_radiation?days=#{days}&unit=watt")
      solar_radiations = get(uri)['data']
      Struct.new('SolarRadiationMetaData', :size, :unit, :device_id)
      @solar_radiations = solar_radiations.map do |solar_radiation|
        Kakaxi::Data::SolarRadiation.new(
          value: solar_radiation['amount'],
          recorded_at: solar_radiation['recorded_at'],
          interpolation: solar_radiation['interpolation']
         )
      end
      @solar_radiation_data = Struct::SolarRadiationMetaData.new(@solar_radiations.length, 'watt',  @current_device.id) 
    end

    def load_rainfalls(days: 5)
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{@current_device.id}/indicators/rainfall?days=#{days}&unit=inch")
      rainfalls = get(uri)['data']
      Struct.new('RainfallMetaData', :size, :unit, :device_id)
      @rainfalls = rainfalls.map do |rainfall|
        Kakaxi::Data::Rainfall.new(value: rainfall['amount'], recorded_at: rainfall['recorded_at'], interpolation: rainfall['interpolation'])
      end
      @rainfall_data = Struct::RainfallMetaData.new(@rainfalls.length, 'inch', @current_device.id)
    end

    def load_timelapses(days: 5)
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{@current_device.id}/indicators/timelapse?days=#{days}")
      timelapses = get(uri)['data']
      Struct.new('TimelapseMetaData', :size, :device_id)
      @timelapses = timelapses.map do |timelapse|
        Kakaxi::Data::Timelapse.new(
          id: timelapse['id'],
          start_datetime: timelapse['beginningTime'],
          end_datetime: timelapse['endTime'],
          url: timelapse['videoURL'],
          thumbnail_name: timelapse['thumbnail']['name'],
          thumbnail_url: timelapse['thumbnail']['url']
        )
      end
      @timelapse_data = Struct::TimelapseMetaData.new(@timelapses.length, @current_device.id)
    end

    def load_interval_photos(pagination: false, start_date: Date.today, end_date: Date.today + 7)
      uri = URI.parse(BASE_URL + "kakaxi_devices/#{@current_device.id}/interval_photos")
      params = { pagination: false, start_date: start_date, end_date: end_date }
      uri.query = URI.encode_www_form(params)
      interval_photos = get(uri)
      Struct.new('IntervalPhotoMetaData', :size, :pagination, :start_date, :end_date)
      @interval_photos = interval_photos.map do |photo|
        Kakaxi::IntervalPhoto.new(
          id: photo['id'],
          url: photo['url'],
          taken_at: photo['takenAt']
          )
      end
      @interval_photo_data = Struct::IntervalPhotoMetaData.new(@interval_photos.size, pagination, start_date, end_date)
    end

    private
    def get_token
      uri = URI.parse(BASE_URL + 'oauth/token')
      params = { username: @email, password: @password, grant_type: 'password', scope: 'all' }
      response = post(uri, params)
      raise InvalidCredentials.new(@email, @password) if response.code == '404'
      JSON.parse(response.body)['access_token']
    end

    def get_farm
      farm = get(URI.parse(BASE_URL + 'users/me'))['farm']
      Kakaxi::Farm.new(id: farm['id'], name: farm['name'])
    end

    def get_devices
      uri = URI.parse(BASE_URL + "farms/#{@farm.id}/kakaxi_devices?pagination=false")
      devices = get(uri)
      devices.map { |device| Kakaxi::Device.new(id: device['id'], name: device['name']) }
    end

    def post(uri, params, header=COMMON_HEADER)
      request = Net::HTTP::Post.new(uri.path)
      request.body = params.to_json
      set_header(header, request)
      https(uri).request(request)
    end

    def get(uri)
      header = COMMON_HEADER.merge('Authorization' => "Bearer #{@token}")
      request = Net::HTTP::Get.new(uri)
      set_header(header, request)
      JSON.parse(https(uri).request(request).body)
    end

    def set_header(header, request)
      header.each { |key, value| request[key] = value }
    end

    def https(uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https
    end

    def indicator_uri(device_id, indicator, days, unit)
      URI.parse(BASE_URL + "kakaxi_devices/#{device_id}/indicators/#{indicator}?days=#{days}")
    end
  end
end
