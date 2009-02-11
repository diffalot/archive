module Archive
  class PayloadFile
    attr_accessor  :payload
    attr_reader    :path
    ALLOWED_PATH_CHARS = %r{\w\-\.}

    def initialize payload, path
      self.payload = payload
      self.path    = path
    end

    def full_path
      File.join(payload.base_path, path)
    end

    def contents
      File.read(full_path)
    end

    def self.canonicalize_path pth
      pth.gsub(%r{[^#{ALLOWED_PATH_CHARS}]+}, '-')
    end

    def path= pth
      @path = self.class.canonicalize_path(pth)
    end

    def file_metadata
      { :format => 'txt', :sha1 => '14123l;sadf25314', :balls => {  :sub => 'what?' } }
    end

    def to_s
      path
    end

    def to_xml options={}
      options['force_attr'] = false
      xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! unless options[:skip_instruct]
      sub_options = options.reject{|k,v| k == :root }
      sub_options.merge :skip_types => true, :skip_instruct => true, 'force_attr' => false
      xml.file(:name => path) do
        file_metadata.each do |key,val|
          xml.tag! key, val
        end
      end
    end

  end
end

