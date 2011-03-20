application_config = "#{::Rails.root.to_s}/config/application.yml"

require 'web_application'
#load the required files from the lib. Don't know if is like this... but it work
#require 'string_utils'

WebApplication::load_configuration(application_config)

#Config mailer
ActionMailer::Base.default_url_options[:host] = WebApplication::config['mail_notifications']['mail_host']

#if production, then use the following



if ::Rails.env == 'production'
  ActionMailer::Base.delivery_method = :smtp  
  ActionMailer::Base.smtp_settings = {
  :address => WebApplication::config['mail_notifications']['address'],
  :port => WebApplication::config['mail_notifications']['port'],
  :domain => WebApplication::config['mail_notifications']['domain'],
  :user_name => WebApplication::config['mail_notifications']['user_name'],
  :password => WebApplication::config['mail_notifications']['password'],
  :authentication => :login
  }  
end
