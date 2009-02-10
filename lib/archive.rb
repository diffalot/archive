require 'rubygems'
require 'active_support'
require 'archive/config'; Archive.load_config!
require 'archive/extensions'
require 'archive/api_response'
require 'archive/repository'
require 'archive/payload_file'
require 'archive/payload'
require 'archive/payload/generic_payload'
require 'archive/payload/audio_payload'
require 'archive/payload/movie_payload'

module Archive
  # Moved User into archive/session/user.rb

  #
  # Moved Item functionality into archive/metadata/item_metadata
  #
  # ## Archive Items can have multiple files described in xml format and a description described in xml format
  # class Item
  #   attr_reader :identifier, :xml_files, :xml_meta
  #   attr_writer :identifier, :xml_files, :xml_meta
  #   def initialize(identifier, xml_files, xml_meta)
  #     @identifier = identifier
  #     @xml_files = xml_files
  #     @xml_meta = xml_meta
  #   end
  # end

  def self.checkin(item, user)
    ##
    Archive::CallAPI(checkin, item, user)
  end

  ## Create a new archive item
  def self.create(item, user)

    Archive.validate_identifier(item, user)
    Archive.upload_files(item.xml_files, user)
    Archive.upload_metadata(item.xml_meta, user)
    Archive.checkin(item)

  end

end
