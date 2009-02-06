module Archive

  ## Users have email and password
  class User
    attr_reader :email, :password
    attr_writer :email, :password
    
    def initialize(email, password)
      @email = email
      @password = password
    end
  end
    
  ## Archive Items can have multiple files described in xml format and a description described in xml format
  class Item
    
    attr_reader :identifier, :xml_files, :xml_meta
    attr_writer :identifier, :xml_files, :xml_meta
    
    def initialize(identifier, xml_files, xml_meta)
      @identifier = identifier
      @xml_files = xml_files
      @xml_meta = xml_meta
    end
    
  end

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