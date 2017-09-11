require 'kakaxi/data/base_data'

module Kakaxi
  module Data
    class Timelapse
      attr_reader :id, :start_datetime, :end_datetime, :url, :thumbnail

      def initialize(id: nil, start_datetime: nil, end_datetime: nil, url: nil, thumbnail_name: nil, thumbnail_url: nil)
        @id = id
        @start_datetime = DateTime.strptime(start_datetime, '%Y-%m-%dT%H:%M:%SZ')
        @end_datetime = DateTime.strptime(end_datetime, '%Y-%m-%dT%H:%M:%SZ')
        @url = URI.parse(url)
        @thumbnail = { name: thumbnail_name, url: thumbnail_url }
      end
    end
  end
end

