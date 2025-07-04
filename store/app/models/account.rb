class Account < ApplicationRecord
    scope :unverified_expired, -> { where(verified: false).where("created_at < ?", 3.days.ago) }

    validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Not a valid email address."}
    # validates :username, uniqueness: { message: "Email already exist."}

    validates :password, length: { minimum: 8, message: "Password too short. Minimun of 8 characters."}
    validates :password, confirmation: { message: "Password does not match."}
    validates :password, format: { with: /\A(?=.*[0-9])(?=.*[^A-Za-z0-9]).+\z/, message: "Password must contain at least 1 number and 1 symbol."}
end
