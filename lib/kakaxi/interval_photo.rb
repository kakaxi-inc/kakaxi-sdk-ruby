module Kakaxi
  class Temperature
    attr_reader :id, :url, :taken_at

    def initialize(id: nil, url: nil, taken_at: nil)
      @id = id
      @url = url
      @taken_at = DateTime.strptime(taken_at, '%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
