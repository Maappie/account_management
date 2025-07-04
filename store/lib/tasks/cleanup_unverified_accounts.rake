namespace :accounts do
  desc "Delete unverified accounts older than 3 days"
  task cleanup_unverified: :environment do
    expired = Account.unverified_expired
    count = expired.count
    expired.destroy_all
    puts "Deleted #{count} unverified accounts older than 3 days."
  end
end
