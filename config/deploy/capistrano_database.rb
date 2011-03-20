require 'erb'


Capistrano::Configuration.instance.load do
  before "deploy:setup", "deploy:db"
  after "deploy:update_code", "deploy:db:symlink" 
  namespace :deploy do
    namespace :db do
      desc "Create database yaml in shared path" 
      task :default do
        db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql2
      encoding: utf8
      reconnect: true
      pool: 5
      server: localhost
      username: #{db_user}
      password: #{Capistrano::CLI.ui.ask("Enter MySQL database password: ")}

    development:
      database: #{application}_development
      <<: *base

    test:
      database: #{application}_test
      <<: *base

    production:
      database: #{application}_production
      <<: *base
    EOF
        
        run "mkdir -p #{shared_path}/config" 
        put db_config.result, "#{shared_path}/config/database.yml" 
      end
      
      desc "Make symlink for database yaml" 
      task :symlink do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
      end
    end
  end
end