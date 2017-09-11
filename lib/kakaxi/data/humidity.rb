require 'kakaxi/data/base_data'

module Kakaxi
  module Data
    class Humidity < BaseData
      attr_reader :deficit

      def initialize(value: nil, recorded_at: nil, interpolation: nil, deficit: nil)
        @deficit = deficit
        super(value: value, recorded_at: recorded_at, interpolation: interpolation)
      end
    end
  end
end

