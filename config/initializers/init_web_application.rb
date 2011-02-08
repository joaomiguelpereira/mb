application_config = "#{::Rails.root.to_s}/config/application.yml"

require 'web_application'
WebApplication::load_configuration(application_config)

#Config mailer
ActionMailer::Base.default_url_options[:host] = WebApplication::config['mail_notifications']['mail_host']

