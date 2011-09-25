$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

set :user, "administrator"
set :branch, "develop"
set :rails_env, "draft"

role :web, "131.203.101.123" # => nzsl-draft.3months.com
role :app, "131.203.101.123" # => nzsl-draft.3months.com
role :db,  "131.203.101.123", :primary => true # => nzsl-draft.3months.com

#RVM Configuration
set :rvm_ruby_string, '1.9.2@nzsl'
set :rvm_type, :user

set :whenever_command, "whenever"

after "deploy:update_code" do
  run "cd #{release_path} && ln -s #{shared_path}/configuration/rvmrc #{release_path}/.rvmrc"
end

