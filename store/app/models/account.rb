class Account < ApplicationRecord
    scope :unverified_expired, -> { where(verified: false).where("created_at < ?", 3.days.ago) }
end
