namespace :db do
  MAX_REQUESTS = 1000
  STORAGE_DAYS = 10

  desc "Limits the requests in the database to the most recent and limit the total number"
  task manage_requests: :environment do
    total_destroyed = 0
    # Delete requests over STORAGE_DAYS days old
    total_destroyed += Request.where("created_at < ?", STORAGE_DAYS.days.ago).destroy_all.length

    # Ensure we have no more than MAX_REQUESTS of the most recent requests
    total_destroyed += Request.order(id: :desc).offset(Request.count - MAX_REQUESTS).destroy_all.length if Request.count > MAX_REQUESTS

    puts "A total of #{total_destroyed} requests were deleted, remaining #{Request.count} requests are those made since #{STORAGE_DAYS.days.ago}."
  end
end
