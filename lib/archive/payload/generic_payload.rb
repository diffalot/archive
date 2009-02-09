module Archive
  #
  # A payload
  # * has flexible metadata
  # * contains files
  #
  class Payload
    attr_accessor :files

    def exists?
    end

    def verify
    end

    #
    # Perform sanity checks before transmission
    #
    def sanity_check
      required_attributes.each do |attr|
        unless self[attr]
          raise "Please specify a value for required attribute #{attr}"
        end
        if files.blank?
          raise "You should include at least one file, or what the heck's the point?" #"
        end
      end
    end # sanity_check
  end
end

