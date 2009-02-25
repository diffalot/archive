module Archive

  #
  # Adds movie item fields:
  #   date, producer, production_company, director, contact, sponsor,
  #   description, runtime, color, sound, shotlist, segments, credits, and
  #   country.
  #
  module MovieItemMetadata
    def self.included base
      base.recommended_attributes += [
        :date, :producer, :production_company, :director, :contact, :sponsor,
        :description, :runtime, :color, :sound, :shotlist, :segments,
        :credits, :country
      ]
    end
  end

  #
  # Movie item metadata object
  #
  # Includes by default fields from GenericItem
  #
  class MovieItem < GenericItem
    include MovieItemMetadata

    def initialize *args
      super *args
      self.mediatype ||= :movie
    end
  end
end
