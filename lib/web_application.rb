module WebApplication
  
  @raw_application_config = {}
  @application_config = {}
  class << self
    
    def load_configuration(application_yaml_file)
      return false unless File.exists?(application_yaml_file)
      
      @raw_application_config = YAML.load( ERB.new( File.read(application_yaml_file)).result)
      if defined? ::Rails.env
        @application_config = @raw_application_config[::Rails.env]
        
      end
      
    end
    
    def config
      @application_config
    end
    
  end
end