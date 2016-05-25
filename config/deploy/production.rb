# Redhat Server running at Victoria University of Wellington
# Technical contact: ITS

set :port, 10
set :user, 'extrabid'
set :branch, 'master'

set :whenever_command, "#{try_sudo} whenever --user root"
set :whenever_command, 'whenever'

require 'capistrano-rbenv'
set :rbenv_ruby_version, '2.2.3'

# Your HTTP server, Apache/etc
role :web, 'vuwunicosldedp3.ods.vuw.ac.nz'

# This may be the same as your `Web` server
role :app, 'vuwunicosldedp3.ods.vuw.ac.nz'

# This is where Rails migrations will run
role :db,  'vuwunicosldedp3.ods.vuw.ac.nz', primary: true
