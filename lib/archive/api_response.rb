module Archive
  class ApiResponse
    attr_accessor :response
    def initialize response_xml
      self.response = self.class.parse_response(response_xml) || {}
    end

    # Delegate attributes to response
    def [](attr)
      response[attr.to_s]
    end

    # Checks if API call succeeded
    def success?
      self[:type] == "success"
    end

    # Convert XML response to its natural hash representation
    def self.parse_response response_xml
      return unless response_xml
      hsh = XmlSimple.xml_in(response_xml, 'force_array' => false)
      hsh.values.each(&:strip!)
      hsh
    end
  end

end
