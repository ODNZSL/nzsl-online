require "whenever/capistrano"
require "bundler/capistrano"

set :application, "nzsl-online"
set :repository,  "git@github.com:3months/nzsl-online.git"
set :deploy_to, "/var/rails/#{application}"

set :scm, :git
default_run_options[:pty] = true
set :deploy_via, :copy
set :copy_cache, '/tmp/deploy-cache/nzsl-online'
set :copy_exclude, [".git", "config/database.yml", "config/deploy.rb", "public/images/signs"]

set :stages, %w(production draft)
set :default_stage, "draft"
require 'capistrano/ext/multistage'




namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after "deploy:update_code" do
  run "cd #{release_path} && ln -s #{shared_path}/cached/images/signs #{release_path}/public/images/"
  run "cd #{release_path} && ln -s #{shared_path}/bundle #{release_path}/vendor/bundle"
  run "#{try_sudo} ln -s #{shared_path}/configuration/database.yml #{release_path}/config/database.yml"
end

