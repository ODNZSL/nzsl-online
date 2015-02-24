#Redhat Server running at Victoria University of Wellington
#Technical contact: ITS

set :user, "brenda"
set :branch, "feature/rails-4"

set :whenever_command, "#{try_sudo} whenever --user root"
set :whenever_command, "whenever"

role :web, "127.0.0.1"
role :app, "127.0.0.1"                          # This may be the same as your `Web` server
role :db,  "127.0.0.1", :primary => true # This is where Rails migrations will run

