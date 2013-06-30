# http://wiki.ocssolutions.com/Step-by-step_setup_using_Capistrano_2.0_and_Mongrel
# 14mradmin
require 'bundler/capistrano'
require "rvm/capistrano"
# require 'sidekiq/capistrano'

set :application, "DayKoozie"
set :scm, "git"
set :repository, "git@github.com:davingee/DayKoozie.git"
# set :repository, "git@github.com:davingee/#{application}.git"
# set :repository, "git@github.com:user/repo.git"  # Your clone URL

set :branch, "deploy"
set :deploy_via, :remote_cache
# set :deploy_via, :checkout

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user_driver, ENV['PGUSER']                           #-> mysql2 user
set :password_driver, ENV['PGPASSWORD']                #-> mysql2 password
set :server_driver,'127.0.0.1'                      #-> host database mysql
set :databasename, 'daykoozie_production'       #-> database name
set :rails_env, "production"
set :domain, '166.78.24.37'
role :web, domain
role :app, domain
role :db,  domain, :primary => true


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

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




# cap production deploy:migrations
# cap production_dev deploy:migrations


set :rvm_ruby_string, '2.0'
# set :rvm_type, :user  # Don't use system-wide RVM
set :rvm_type, :system

set :user, 'mradmin'
set :scm_passphrase, "14mradmin"
set :deploy_to, "/home/mradmin/DayKoozie"
# set :current_path, "/home/samurai/current"
set :current_path, "/home/mradmin/DayKoozie"
set :use_sudo, true   # for some error not sure yet but just need the password one time

set :scm_verbose, true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
 
set :keep_releases, 5
 
namespace :deploy do
 
  # desc "dumps production db to #{deploy_to}/backup."
  # task :dump_db do
  #   # run "RAILS_ENV=#{development} bundle exec rake db:migrate"
  #   run "mysqldump -u #{user_driver} --password=#{password_driver} -h #{server_driver} #{databasename} > #{deploy_to}/backup/#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}_#{rails_env}.sql"
  # end
  #  
  # desc "backup system folder(pictures and such) to #{deploy_to}/backup."
  # task :backup_system_folder do
  #   run "cp -R  #{shared_path}/system #{deploy_to}/backup/#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}_system"
  # end
  #  
  # desc "backup assets folder to #{deploy_to}/backup."
  # task :backup_assets_folder do
  #   if previous_release
  #     run "cp -R  #{shared_path}/assets #{deploy_to}/backup/#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}_assets"
  #   end
  # end
 
  desc "restarts server."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
 
  desc "Installs required gems"  
  task :gems, :roles => :app do  
    run "cd #{current_path} && sudo rake gems:install RAILS_ENV=production"  
  end  
 
  # https://github.com/ndbroadbent/turbo-sprockets-rails3  
  # namespace :assets do
  #   task :precompile, :roles => :web, :except => { :no_release => true } do
  #     from = source.next_revision(current_revision)
  #     if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
  #       run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #     else
  #       logger.info "Skipping asset pre-compilation because there were no asset changes"
  #     end
  #   end
  # end
  
end
 
# before 'deploy:update_code', 'deploy:dump_db', 'deploy:backup_system_folder'#, 'deploy:backup_assets_folder'
# after "deploy:setup", "deploy:gems"     
after 'deploy', 'deploy:restart', 'deploy:cleanup'
