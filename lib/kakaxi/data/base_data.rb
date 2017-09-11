module Kakaxi
  module Data
    class BaseData
      attr_reader :value, :recorded_at, :interpolation

      def initialize(value: nil, recorded_at: nil, interpolation: nil)
        @value = value
        @recorded_at = DateTime.strptime(recorded_at, '%Y-%m-%dT%H:%M:%SZ')
        @interpolation = interpolation
      end
    end
  end
end

