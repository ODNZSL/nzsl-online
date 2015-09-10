require 'bundler/capistrano'
# require "whenever/capistrano"

set :application, 'nzsl-online'
set :repository,  './'
set :deploy_to, "/var/rails/#{application}"

set :scm, :none
default_run_options[:pty] = true
set :deploy_via, :copy
# set :copy_cache, '/tmp/deploy-cache/nzsl-online'
set :copy_exclude, ['.git', 'config/database.yml', 'config/deploy.rb', 'public/images/signs', '.bundle', 'db/*.sqlite3', 'log/*.log', 'tmp/**/*', '.rvmrc', '.DS_Store', 'public/videos/', 'public/system/videos/', 'config/initializers/access.rb']
set :use_sudo, false

# If this breaks on a mac, you need to `brew install gnu-tar`
set :copy_local_tar, 'tar'
set :copy_local_tar, '/usr/local/bin/gtar' if `uname` =~ /Darwin/

# Make the remote and local dirs different, so we can test by deploying to localhost
set :remote_copy_dir, '/tmp/deploy-remote'
set :copy_dir, '/tmp/deploy-local'

set :stages, %w(production staging draft)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

after 'deploy:update_code' do
  run "cd #{release_path} && ln -s #{shared_path}/cached/images/signs #{release_path}/public/images/"

  run "cd #{release_path} && ln -s #{shared_path}/videos #{release_path}/public/videos"

  run "cd #{release_path} && ln -s #{shared_path}/bundle #{release_path}/vendor/bundle"

  # our database config is not in git
  run "ln -s #{shared_path}/configuration/database.yml #{release_path}/config/database.yml"

  # and our user/pass file is not in git
  run "ln -s #{shared_path}/configuration/access.rb #{release_path}/config/initializers/access.rb"

  # unicorn config (for those env that use unicorn)
  run "ln -s #{shared_path}/configuration/unicorn.rb #{release_path}/config/unicorn.rb"

  # link in our database
  run("ln -s #{shared_path}/nzsl_development.sqlite3 #{release_path}/db/nzsl_development.sqlite3")
end

namespace :rabid do
  desc 'Compress assets in a local file'
  task :compress_assets do
    run_locally('rm -rf public/assets/*')
    # this precompile task is done in production env to ensure that the assets have the digests on them
    run_locally('bundle exec rake assets:precompile RAILS_ENV=production')
    run_locally('touch assets.tgz && rm assets.tgz')
    run_locally("#{copy_local_tar} zcvf assets.tgz public/assets/")
    run_locally('mv assets.tgz public/assets/')
  end

  desc 'Upload assets'
  task :upload_assets do
    upload('public/assets/assets.tgz', release_path + '/assets.tgz')
    run "cd #{release_path}; tar zxvf assets.tgz; rm assets.tgz"
  end
  desc 'Make local and remote dirs'
  task :make_dirs do
    # note we make the local and remote folders different, so we can deploy to localhost

    # local build folder
    run_locally("mkdir -p #{copy_dir}")

    # remote landing folder for tar ball
    run("mkdir -p #{remote_copy_dir}")

    # create log file folder on server, (or cold deploy will fail)
    run("mkdir -p #{shared_path}/log")

    run('mkdir -p /var/rails/nzsl-online && mkdir -p /var/rails/nzsl-online/releases')

    run('mkdir -p /var/rails/nzsl-online/shared/system')
  end
  desc 'make pid dir'
  task :make_pid_dir do
    # make the folder the pid file is kept in
    run('mkdir -p /var/rails/nzsl-online/current/pids/')
  end
end

before 'deploy:update_code', 'rabid:make_dirs'
before 'deploy:update_code', 'rabid:compress_assets'
after 'deploy:symlink', 'rabid:upload_assets'
after 'deploy:symlink', 'rabid:make_pid_dir'
