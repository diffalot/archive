module Archive
  class Payload < OpenStruct
    # These attributes are required for acceptance
    class_inheritable_accessor :required_attributes
    self.required_attributes = [].to_set

    # These attributes are recommended but may be omitted.
    # They will show up as present-but-empty fields in the metadata store
    class_inheritable_accessor :recommended_attributes
    self.recommended_attributes = [].to_set

    # The contained PayloadFiles
    attr_reader :files

    #
    #
    def initialize *args
      # the files list is handled separately
      initial_files = args.delete(:files)
      super *args
      # I am who I am
      canonicalize_identifier!
      # add initial list of files
      self << initial_files if initial_files
    end

    # expected attributes: the required attributes and the recommended attributes
    def expected_attributes
      required_attributes + recommended_attributes
    end

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
      files_to_add.each do |payload_file|
        case payload_file
        when PayloadFile # PayloadFiles go right in
          files << payload_file
        else             # Otherwise, whip up a new one from filename
          files << PayloadFile.new_from_path(payload_file)
        end
      end
    end

    #
    # Perform sanity checks before transmission
    #
    def sanity_check
      sanity_check_required_attributes
      sanity_check_has_files
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
      title.gsub(/[^\w\-\.]+/, '_')
    end

    # ---------------------------------------------------------------------------
    # Sanity checks
    #

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

  end
end
