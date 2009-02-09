require 'set'
module Archive
  module Metadata
    #
    #
    # Generates the IDENTIFIER_meta.xml file for bulk upload to archive.org.
    #
    # [identifier]
    #   The identifier used to locate the item on the servers and provide the
    #   content to the users. When you upload a directory, the name of the
    #   directory is the unique identifier used. Identifiers can only contain
    #   letters, numbers, underscores, dashes, and dots (nothing else!)
    #   All items must have a value for this field
    #
    # [title]
    #   Item's title.  All items must have a value for this field
    #
    # [description]
    #   Item's description.  All items must have a value for this field
    #
    # [collection]
    #   Item's collection.  All items must have a value for this field
    #
    # [mediatype]
    #   Item's collection.  All items must have a value for this field
    #
    # [licenseurl]
    #
    #   You may optionally set a Creative Commons license for your item by
    #   setting licenseurl to one of the values from the list in
    #     docs/archive.org-list_of_licenses.txt
    #   (Or see [Creative Commons' list]:http://creativecommons.org/licenses/publicdomain/location
    #   So, for example, if you wanted the Public Domain license, you would set
    #     item.licenseurl = 'http://creativecommons.org/licenses/publicdomain/'
    #
    # [... more attributes]
    #    You can include whatever other fields you like. Some fields will be
    #    displayed on the website. These are specified in the ItemMetadata
    #    subclasses defined here.  Any other fields will be kept in the XML file
    #    and will, in the future, be shown on the website. For a good example
    #    check this metadata file.
    #
    # Example: for a movie called "My Home Movie", showing your first vacation
    # to the moon, consisting one file named MyHomeMovie.mpeg, encoded in the
    # MPEG2 format, with a running time of 2:30, directed by "Joe Producer" and
    # a unique identifier of my_home_movie.
    #
    # my_home_movie = MovieItem.new :identifier => :my_home_movie,
    #   :collection  => 'opensource_movies',
    #   :title       => 'My Home Movie',
    #   :description => 'Our Vacation to the moon',
    #   :runtime     => '2:30',
    #   :director    => 'Joe Producer'
    #
    # The item metadata struct would look like this:
    #
    #       <metadata>
    #         <collection>opensource_movies</collection>
    #         <mediatype>movies</mediatype>
    #         <description>Our Vacation to the moon</description>
    #         <title>My Home Movie</title>
    #         <runtime>2:30</runtime>
    #         <director>Joe Producer</director>
    #       </metadata>
    #
    #
    class GenericPayload
      self.required_attributes += [
        :identifier, :title, :description, :collection, :mediatype,
      ]
      self.recommended_attributes += [ :licenseurl ]
    end

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
    # Includes by default fields from GenericPayload and
    # AudioItemMetadata
    #
    class MovieItem < GenericPayload
      include MovieItemMetadata

      def initialize *args
        super *args
        self.mediatype ||= :movie
      end
    end

    #
    # Adds Audio item fields:
    #   creator, description, taper, source, runtime, date, and notes.
    #
    module AudioItemMetadata
      def self.included base
        base.required_attributes += [
          :creator, :description, :taper, :source, :runtime, :date, :notes
        ]
      end
    end

    # Metadata for an Audio item
    #
    # Includes by default fields from GenericPayload and
    # AudioItemMetadata
    #
    class AudioItem < GenericPayload
      include AudioItemMetadata
    end
  end
end


