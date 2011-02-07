application_config = "#{RAILS_ROOT}/config/application.yml"

require 'application'
APPLICATION = Application::load_configuration(application_config)
