require 'ostruct'
OpenStruct.class_eval do
  #
  # Convert to XML using
  #
  def to_xml options={}
    to_hash.to_xml(options)
  end

  #
  # convert to hash with all set values
  #
  def to_hash
    @table.dup
  end

  #
  # Finds value for the corresponding member
  #
  def [](attr)
    self.send(attr)
    # @table[attr]
  end

  #
  # Sets the corresponding member
  #
  def []=(attr, val)
    self.send("#{attr}=", val)
  end
end
