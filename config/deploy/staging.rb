set :user, "nzsl"
set :branch, "feature/rails-4"

set :whenever_command, "#{try_sudo} whenever --user root"
set :whenever_command, "whenever"

role :web, "journey.rabid.co.nz"
role :app, "journey.rabid.co.nz"                          # This may be the same as your `Web` server
role :db,  "journey.rabid.co.nz", :primary => true # This is where Rails migrations will run


