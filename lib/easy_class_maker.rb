module Archive

  module EasyClassMaker

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # creates the attributes class variable and creates each attribute's accessor methods
      def attributes(*attrs)
        @@attributes = attrs
        @@attributes.each { |a| attr_accessor a }
      end

      # read method for attributes class variable
      def self.attributes; @@attributes end
    end

    # allows for any class that includes this to use a block to initialize
    # variables instead of assigning each one seperately
    # 
    # Example: 
    # 
    # instead of...
    # 
    # a = Archive.new
    # a.foo = 'thing'
    # a.bar = 'another thing'
    #
    # you can ...
    # 
    # Archive.new do |a|
    #   a.foo = 'thing'
    #   a.bar = 'another thing'
    # end
    def initialize
      yield self if block_given?
    end
  end
end