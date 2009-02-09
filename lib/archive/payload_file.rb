module Archive
  class PayloadFile
    attr_accessor  :path
    ALLOWED_PATH_CHARS = %r{\w\-\.}

    def initialize path
      self.path = path
    end

    def contents
    end


    def self.canonicalize_path
      path.gsub(%r{[^#{ALLOWED_PATH_CHARS}]+}, '-')
    end

    def path= path
      @path = self.class.canonicalize_path(path)
    end
  end
end

