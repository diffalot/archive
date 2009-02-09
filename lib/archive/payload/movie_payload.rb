module Archive
  module Payload

    #
    # Adds movie payload fields:
    #   date, producer, production_company, director, contact, sponsor,
    #   description, runtime, color, sound, shotlist, segments, credits, and
    #   country.
    #
    module MoviePayloadMetadata
      def self.included base
        base.recommended_attributes += [
          :date, :producer, :production_company, :director, :contact, :sponsor,
          :description, :runtime, :color, :sound, :shotlist, :segments,
          :credits, :country
        ]
      end
    end

    #
    # Movie payload metadata object
    #
    # Includes by default fields from GenericPayload and
    # AudioPayloadMetadata
    #
    class MoviePayload < GenericPayload
      include MoviePayloadMetadata

      def initialize *args
        super *args
        self.mediatype ||= :movie
      end
    end
  end
end
