module Application
  
  @raw_application_config = {}
  @application_config = {}
  class << self
    
    def load_configuration(application_yaml_file)
      return false unless File.exists?(application_yaml_file)
      puts "loading "+application_yaml_file
      @raw_application_config = YAML.load( ERB.new( File.read(application_yaml_file)).result)
      if defined? RAILS_ENV
        @application_config = @raw_application_config[RAILS_ENV]
        
      end
      puts @application_config["mail_notifications"]
    end
    
    def config
      @application_config
    end
    
  end
end