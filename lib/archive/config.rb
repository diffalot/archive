module Archive
  mattr_accessor :config, :config_file_location
  self.config_file_location = File.dirname(__FILE__) + '/../../config/archive-private.yaml'

  def self.load_config!
    self.config = YAML.load(File.open(self.config_file_location))
  end
end
