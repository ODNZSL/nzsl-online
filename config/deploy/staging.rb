set :user, "nzsl"
set :branch, "feature/rails-4"
# set :branch, "rl/fix-flowplayer"

set :whenever_command, "#{try_sudo} whenever --user root"
set :whenever_command, "whenever"

role :web, "nzsl.staging.rabid.co.nz"
role :app, "nzsl.staging.rabid.co.nz"                          # This may be the same as your `Web` server
role :db,  "nzsl.staging.rabid.co.nz", :primary => true # This is where Rails migrations will run


