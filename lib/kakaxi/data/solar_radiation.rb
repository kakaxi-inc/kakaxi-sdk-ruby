require 'kakaxi/data/base_data'

module Kakaxi
  module Data
    class SolarRadiation < BaseData
      attr_reader :unit

      def initialize(value: nil, recorded_at: nil, interpolation: nil, unit: nil)
        @unit = unit
        super(value: value, recorded_at: recorded_at, interpolation: interpolation)
      end
    end
  end
end

