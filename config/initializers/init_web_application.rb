application_config = "#{::Rails.root.to_s}/config/application.yml"

require 'web_application'
#load the required files from the lib. Don't know if is like this... but it work
#require 'string_utils'

WebApplication::load_configuration(application_config)
puts "---------------------"
puts WebApplication::config['mail_notifications']['mail_host']
puts WebApplication::config['mail_notifications']['default_mail_from']

#Config mailer
ActionMailer::Base.default_url_options[:host] = WebApplication::config['mail_notifications']['mail_host']

