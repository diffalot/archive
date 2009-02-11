module Archive
  #
  # An infochimps.org collection dataset.
  #
  # See also the documentation for [BasePayload]
  #
  class InfochimpsPayload < GenericPayload
    self.required_attributes += [
      :identifier, :title, :description, :collection, :mediatype,
    ]
    self.recommended_attributes += [ :licenseurl ]

    #
    # TODO: 
    #   :id => :identifier 
    #   :tags => :subject
    #
    
    def initialize *args
      super *args
      self.collection ||= 'infochimps' # test_collection' # 
    end
    
  end
end

