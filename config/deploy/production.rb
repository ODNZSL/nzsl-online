# Redhat Server running at Victoria University of Wellington
# Technical contact: ITS

set :port, 10
set :user, 'extrabid'
set :branch, 'master'

set :whenever_command, "#{try_sudo} whenever --user root"
set :whenever_command, 'whenever'

role :web, 'nzsl.vuw.ac.nz'                          # Your HTTP server, Apache/etc
role :app, 'nzsl.vuw.ac.nz'                          # This may be the same as your `Web` server
role :db,  'nzsl.vuw.ac.nz', primary: true # This is where Rails migrations will run
