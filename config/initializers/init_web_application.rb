application_config = "#{::Rails.root.to_s}/config/application.yml"

require 'web_application'
#load the required files from the lib. Don't know if is like this... but it work
#require 'string_utils'

WebApplication::load_configuration(application_config)

#Config mailer
ActionMailer::Base.default_url_options[:host] = WebApplication::config['mail_notifications']['mail_host']

#if production, then use the following
puts ::Rails.env

puts "Loading smtp setting if in production..."
if ::Rails.env == 'production'
  ActionMailer::Base.server_settings = {
  :address => "mail.domain.com",
  :port => 25,
  :domain => "mail.domain.com",
  :user_name => "email_account_login",
  :password => "email_account_password",
  :authentication => :login
  }  
end
