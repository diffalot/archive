require 'uri'
require 'net/http'
require 'net/ftp'
require 'rubygems'
require 'hpricot'
require 'xmlsimple'

module Archive
  SourceName = 'ArchiveGem'
  
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
  
  class ArchiveItem
    
    include EasyClassMaker
    
    attributes :archive_identifier, :xml_files, :xml_meta
    
    class << self
      def new(archive_identifier, xml_files, xml_meta)
        ArchiveItem.new do |i|
          i.archive_identifier    = archive_identifier
          i.xml_files             = xml_files
          i.xml_meta              = xml_meta
        end
      end
    end
  end
    
    
  ## Archive.create('archive@user.email', 'password', 'ArchiveIdentifier', 'files_xml', 'metadata_xml')
  def self.create(archive_user, archive_password, archive_identifier, xml_files, xml_meta) 
    
    #c = ArchiveItem.new(archive_identifier, xml_files, xml_meta)
    
    create_xml = Net::HTTP.get(URI.parse('http://www.archive.org/create.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
    
    create = XmlSimple.xml_in(create_xml)
    
    uri = URI.parse('ftp://' + create['url'].to_s)
    path = uri::path

    ftp = Net::FTP.new(uri.host)
    ftp.login(user = archive_user, archive_password)
    ftp.chdir(path)
    ftp.putbinaryfile('/test.jpg')
    ftp.close
      
    response = Net::HTTP.get(URI.parse('http://www.archive.org/checkin.php?identifier=' + archive_identifier + '&xml=1&user=' + archive_user))
    puts response
  end
end