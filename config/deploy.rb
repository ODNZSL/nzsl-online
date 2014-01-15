require "bundler/capistrano"
# require "whenever/capistrano"

set :application, "nzsl-online"
set :repository,  "./"
set :deploy_to, "/var/rails/#{application}"

set :scm, :none
default_run_options[:pty] = true
set :deploy_via, :copy
# set :copy_cache, '/tmp/deploy-cache/nzsl-online'
set :copy_exclude, [".git", "config/database.yml", "config/deploy.rb", "public/images/signs", ".bundle", "db/*.sqlite3", "log/*.log", "tmp/**/*", ".rvmrc", ".DS_Store", "public/videos/", "public/system/videos/", "config/initializers/access.rb"]
set :use_sudo, false
set :copy_local_tar, "/usr/local/bin/gnutar" if `uname` =~ /Darwin/

set :stages, %w(production draft)
set :default_stage, "draft"
require 'capistrano/ext/multistage'




namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after "deploy:update_code" do
  run "cd #{release_path} && ln -s #{shared_path}/cached/images/signs #{release_path}/public/images/"
  run "cd #{release_path} && ln -s #{shared_path}/bundle #{release_path}/vendor/bundle"
  run "ln -s #{shared_path}/configuration/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/configuration/access.rb #{release_path}/config/initializers/access.rb"
end

namespace :rabid do
  desc "Compress assets in a local file"
  task :compress_assets do
    run_locally("rm -rf public/assets/*")
    run_locally("bundle exec rake assets:precompile")
    run_locally("touch assets.tgz && rm assets.tgz")
    run_locally("tar zcvf assets.tgz public/assets/")
    run_locally("mv assets.tgz public/assets/")
  end

  desc "Upload assets"
  task :upload_assets do
    upload("public/assets/assets.tgz", release_path + '/assets.tgz')
    run "cd #{release_path}; tar zxvf assets.tgz; rm assets.tgz"
  end
end
before "deploy:update_code", "rabid:compress_assets"
after "deploy:symlink", "rabid:upload_assets"
