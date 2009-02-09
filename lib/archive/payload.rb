require 'fileutils'
module Archive
  class Payload < OpenStruct
    attr_accessor  :files, :base_path
    #
    #
    def initialize base_path, attr_hash
      self.base_path = base_path
      # the files list is handled separately
      initial_files = attr_hash.delete(:files)
      super attr_hash
      # I am who I am
      canonicalize_identifier!
      # add initial list of files
      self.files = []
      self << initial_files if initial_files
    end

    # ---------------------------------------------------------------------------
    #
    # Metadata Attributes
    #

    # These attributes are required for acceptance
    class_inheritable_accessor :required_attributes
    self.required_attributes = [].to_set
    # These attributes are recommended but may be omitted.
    # They will show up as present-but-empty fields in the metadata store
    class_inheritable_accessor :recommended_attributes
    self.recommended_attributes = [].to_set
    # expected attributes: the required attributes and the recommended attributes
    def expected_attributes
      required_attributes + recommended_attributes
    end

  protected
    # Any unset attributes are initialized to nil, ensuring the corresponding
    # empty tag is set in the metadata file in order to scold you into setting
    # it.
    def register_expected_attributes
      expected_attributes.each{|attr| self[attr] ||= nil }
    end

    #
    # Checks that identifier either exists or can be pulled from the title
    #
    def canonicalize_identifier!
      self.identifier ||= identifier_from_title
      if (! self.identifier)
        raise "Please specify either an explicit identifier, or a title to generate an identifier from."
      end
    end

    #
    # Identifiers can only contain letters, numbers, underscores, dashes, and
    # dots (nothing else!)
    #
    def identifier_from_title
      return unless title
      title.downcase.gsub(/[^\w\-\.]+/, '_')
    end
  public

    # ---------------------------------------------------------------------------
    #
    # Archive.org format metadata files
    #

    #
    # XML describing the payload metadata
    #
    def archive_org_metadata context
      case context
      when :payload_metadata
        options={ :root => 'metadata' }
        to_xml(options)
      when :files_listing
        options={ :root => 'files', :skip_types => true }
        # files.to_xml(options)
        [].to_xml(options)
      else
        raise "Don't know how to generate metadata for #{context}"
      end
    end

    def metadata_file_path context
      case context
      when :payload_metadata  then filename = "#{identifier}_meta.xml"
      when :files_listing     then filename = "#{identifier}_files.xml"
      else raise "Don't know where to find metadata for #{context}"
      end
      File.join(base_path, filename)
    end

    #
    # Writes the metadata out to disk
    #
    def save_metadata!
      sanity_check
      [:payload_metadata, :files_listing].each do |context|
        File.open(metadata_file_path(context), "w") do |metadata_file|
          metadata_file << archive_org_metadata(context)
        end
      end
    end

    # ---------------------------------------------------------------------------
    #
    # Contained Files
    #

    # The contained PayloadFiles
    attr_reader :files

    #
    # Alias for add_files
    #
    def <<(*files_to_add)
      add_files *files_to_add
    end

    #
    # Adds the given (PayloadFiles or file paths) to the payload
    #
    def add_files *files_to_add
      files_to_add = files_to_add.flatten # one, many, who cares
      files_to_add.each do |file_to_add|
        case file_to_add
        when PayloadFile # PayloadFiles go right in
          files << file_to_add
        else
          files << PayloadFile.new(self, file_to_add)
        end
      end
    end

    #
    # Copies each file into the payload directory
    # and adds it to the list of files
    #
    def copy_over_and_add_files *files_to_add
      files_to_add = files_to_add.flatten # one, many, who cares
      files_to_add.each do |file_to_add|
        src_path     = file_to_add
        dest_path    = File.basename(file_to_add)
        payload_file = PayloadFile.new(self, dest_path)
        # Copy the file over
        mkdir!
        FileUtils.cp src_path, payload_file.full_path
        # Add it to our collection
        self << payload_file
      end
    end

    def self.new_from_dir base_path, payload_metadata={}
      identifier = File.basename(base_path)
      # include all the files in there
      files = Dir[base_path+'/*'].map{|f| File.basename(f) }
      # ... except for the metadata files
      files.reject!{|f| f =~ /_(meta|files)\.xml$/ }
      # lay in the metadata we got
      payload_metadata = payload_metadata.reverse_merge :identifier => identifier, :files => files
      new base_path, payload_metadata
    end

  protected
    def mkdir!
      FileUtils.mkdir_p base_path
    end
    # ---------------------------------------------------------------------------
    #
    # Sanity Checks
    #

    #
    # Perform sanity checks before transmission
    # raises if there are problems
    #
    def sanity_check!
      sanity_check_required_attributes
      sanity_check_has_files
      true # nothing raised, so: success
    end

    #
    # Sanity check, but warn -- don't raise
    # returns true/nil for passed/failed
    #
    def sanity_check
      begin
        sanity_check!
      rescue Exception => e
        warn e
        nil
      end
    end

  protected
    def sanity_check_required_attributes
      required_attributes.each do |attr|
        raise "Please specify a value for required attribute #{attr}" unless self[attr]
      end
    end
    def sanity_check_has_files
      if files.blank?
        raise "You should include at least one file, or what the heck's the point?" #"
      end
    end
  public

  end
end
