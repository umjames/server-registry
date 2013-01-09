require 'bundler/capistrano'
require File.join(File.dirname(__FILE__), "deploy", "capistrano_database_yml")
require File.join(File.dirname(__FILE__), "deploy", "asset_pipeline")

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "server-registry-server"
set :repository,  "git@github.com:ShindigIO/server-registry.git"
set :deploy_to, "/home/#{user}/webapps/#{application}"

set :deploy_via, :remote_cache
set :scm, :git
set :branch, "master"

set :user, "software"
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :rails_env, "production"
set :shindig_db_backup_path, "~/bin/shindig_db_backup"

role :web, "app1.shindig.io"                          # Your HTTP server, Apache/etc
role :app, "app1.shindig.io"                          # This may be the same as your `Web` server
role :db,  "app1.shindig.io", :primary => true # This is where Rails migrations will run
role :db,  "admindb.shindig.io", :no_release => true # production database server


task :staging do
  set :branch, "development"
  set :rails_env, "staging"   # setting this for running migrations
  set :deploy_env, "staging"
  set :database_name, "server_registry_staging"
  set :shindig_db_backup_path, "~/bin/shindig_db_backup"
  role :web, "stage.shindig.io"                          # Your HTTP server, Apache/etc
  role :app, "stage.shindig.io"                          # This may be the same as your `Web` server
  role :db,  "stage.shindig.io", :primary => true # This is where Rails migrations will run
  
  set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT=\"/servers\""
  
  before "deploy:finalize_update", "deploy:assets:symlink"
  after "deploy:create_symlink", "deploy:assets:precompile"
end

task :qa do
  set :branch, "qa"
  set :rails_env, "qa"   # setting this for running migrations
  set :deploy_env, "qa"
  set :database_name, "server_registry_qa"
  set :shindig_db_backup_path, "~/bin/shindig_db_backup"
  role :web, "qa.shindig.io"                          # Your HTTP server, Apache/etc
  role :app, "qa.shindig.io"                          # This may be the same as your `Web` server
  role :db,  "qa.shindig.io", :primary => true # This is where Rails migrations will run
  
  set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT=\"/servers\""
  
  before "deploy:finalize_update", "deploy:assets:symlink"
  after "deploy:create_symlink", "deploy:assets:precompile"
end

task :production do
  set :branch, "master"
  set :deploy_env, "production"
  set :database_name, "server_registry_prod"
  set :shindig_db_backup_path, "~/bin/shindig_db_backup"
  role :web, "app1.shindig.io"                          # Your HTTP server, Apache/etc
  role :app, "app1.shindig.io"       # This may be the same as your `Web` server
  role :db, "app1.shindig.io", :primary => true # This is where Rails migrations will run
  role :db, "admindb.shindig.io", :no_release => true # Production database server
  
  set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT=\"/servers\""

  before "deploy:finalize_update", "deploy:assets:symlink"
  after "deploy:update_code", "deploy:db:delete_repo_database_yml"
  after "deploy:setup", "deploy:db:setup"   unless fetch(:skip_db_setup, false)
  after "deploy:create_symlink", "deploy:db:symlink", "deploy:assets:precompile"
end


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  before "deploy:migrate", "db:backup"
  after "deploy:migrate", "db:delete_backup"
end

namespace :db do
  desc "Make a logical backup of the database"
  task :backup, :roles => :db do
    run "if [ -x ~/bin/shindig_db_backup ]; then #{shindig_db_backup_path} -d ~/migration_backups -o #{deploy_env}_migration_backups #{database_name}; fi" do |channel, stream, data|
      raise "#{data}" if data.to_s.length > 0
    end
  end

  desc "Delete database backup after migrations run"
  task :delete_backup, :roles => :db do
    run "if [ -d ~/migration_backups ]; then rm -Rf ~/migration_backups; fi"
  end
end
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end