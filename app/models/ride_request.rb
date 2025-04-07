# class RideRequest < ApplicationRecord
#     validates :name, :phone, :location, :destination, presence: true
#     validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
#   end

class RideRequest < ApplicationRecord
  belongs_to :user

  validates :name, :phone, :location, :destination, presence: true
  validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
  validates :number_of_passengers,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2, message: "Online requests are limited to 2 passengers. Please call 813-974-SAFE (7233) for larger groups."
          },
            allow_nil: false
  validate :passenger_limit

  private
  def passenger_limit
    if number_of_passengers.present? && number_of_passengers > 2
      errors.add(:number_of_passengers, "Online requests are limited to 2 people. Please call instead.")
    end
  end
end