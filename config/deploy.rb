$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'deploy')

require 'capistrano_database'
require 'capistrano_app_settings'

set :application, "medibooking"

default_run_options[:pty] = true
set :repository,  "git://github.com/jmrp/mb.git"
set :scm, :git
set :user, "rails"  # The server's user for deploys


set :db_user, "rails"  # The DB's user name
set :db_name, "medibooking_production"  # DB name


set :deploy_to, "/home/rails/apps/demo.medibooking"
role :web, "demo.medibooking.com"                          # Your HTTP server, Apache/etc
role :app, "demo.medibooking.com"                          # This may be the same as your `Web` server
role :db,  "demo.medibooking.com", :primary => true # This is where Rails migrations will run

#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end