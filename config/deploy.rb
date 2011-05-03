require "whenever/capistrano"

set :application, "nzsl-online"
set :repository,  "git@github.com:3months/nzsl-online.git"
set :deploy_to, "/var/rails/#{application}"

set :scm, :git
default_run_options[:pty] = true 
set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, [".git", "config/database.yml", "config/deploy.rb"]

set :port, 10
set :user, "robertja" 

set :whenever_command, "#{try_sudo} whenever --user root"

role :web, "nzsl.vuw.ac.nz"                          # Your HTTP server, Apache/etc
role :app, "nzsl.vuw.ac.nz"                          # This may be the same as your `Web` server
role :db,  "nzsl.vuw.ac.nz", :primary => true # This is where Rails migrations will run

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after "deploy:update_code" do
  run "cd #{release_path} && ln -s #{shared_path}/system/bundle #{release_path}/vendor/bundle"
  run "cd #{release_path} && bundle install --deployment --without=development test"
  run "#{try_sudo} ln -s #{shared_path}/system/database.yml #{release_path}/config/database.yml"
end
