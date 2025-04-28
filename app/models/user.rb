class User < ApplicationRecord
    has_secure_password

    def admin?
        role == "admin"
      end
    
    def user?
        role == "user"
        end

    validates :username,
        presence: true,
        uniqueness: true,
        length: { minimum: 3, maximum: 250 },
        format: { with: /\A[a-zA-Z0-9]+\z/, message: "must only contain letters and numbers" }
    
    
    validates :password,
    length: { minimum: 8 },
    format: {
        with: /\A(?=.*\d)(?=.*[!@#$&*.<>\?\/]).{8,}\z/,
        message: "must be at least 8 characters and include one number and one special character (!@#$&*.<>/?)"
    },
    if: :validate_password?
    has_many :ride_requests

    private

    def validate_password?
      password_digest_changed? || new_record?
    end
end