require 'capistrano_smtp_settings'


Capistrano::Configuration.instance.load do
  before "deploy:setup", "deploy:app_settings"
  after "deploy:update_code", "deploy:app_settings:symlink" 
  namespace :deploy do
    namespace :app_settings do
      desc "Create application.yml in shared folder" 
      task :default do
        db_config = ERB.new <<-EOF
    production:
      application_name: #{application}
      mail_notifications:
        mail_host: #{mail_host}
        default_mail_from: #{default_mail_from}
        address: #{smtp_address}
        port: #{smtp_port}
        domain: #{smtp_domain}
        user_name: #{smtp_user_name}
        password: #{Capistrano::CLI.ui.ask("Enter SMTP password: ")}
    EOF
        
        run "mkdir -p #{shared_path}/config" 
        put db_config.result, "#{shared_path}/config/application.yml" 
      end
      
      desc "Make symlink for application yaml" 
      task :symlink do
        run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml" 
      end
    end
  end
end