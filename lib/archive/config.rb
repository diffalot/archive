module Archive
  mattr_accessor :config, :config_file_location
  self.config_file_location = File.dirname(__FILE__) + '/../../config/archive-private.yaml'

  def self.load_config!
    if (! File.exists?(self.config_file_location) )
      raise %Q{ Can\'t find config file #{self.config_file_location}.
        Check the path or make a copy of config/archive-sample.yaml and fill in your own information.}
    end
    self.config = YAML.load(File.open(self.config_file_location))
  end
end
