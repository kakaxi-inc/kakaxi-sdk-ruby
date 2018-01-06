require 'kakaxi/data/base_data'

module Kakaxi
  module Data
    class Rainfall < BaseData
      def initialize(value: nil, recorded_at: nil, interpolation: nil, unit: nil)
        super(value: value, recorded_at: recorded_at, interpolation: interpolation)
      end
    end
  end
end

