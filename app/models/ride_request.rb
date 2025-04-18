# class RideRequest < ApplicationRecord
#     validates :name, :phone, :location, :destination, presence: true
#     validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
#   end

class RideRequest < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates :name, :phone, :location, :destination, presence: true
  validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
  validates :number_of_passengers,
            presence: true,
            numericality: { 
              only_integer: true, 
              greater_than_or_equal_to: 1, 
              less_than_or_equal_to: 2, 
              message: "Online requests are limited to 2 passengers. Please call 813-974-SAFE (7233) for larger groups."
          },
            allow_nil: false

  validate :passenger_limit

  private
  def passenger_limit
    if number_of_passengers.blank?
      errors.add(:number_of_passengers, "The number of passengers must be a number")
    elsif !is_numeric?(number_of_passengers)
      errors.add(:number_of_passengers, "The number of passengers must be a number")
    elsif number_of_passengers.to_i < 1
      errors.add(:number_of_passengers, "You must have at least 1 passenger.")
    elsif number_of_passengers.to_i > 2
      errors.add(:number_of_passengers, "Online requests are limited to 2 passengers. Please call 813-974-SAFE (7233) for larger groups.")
    end
  end

  def is_numeric?(value)
    true if Float(value) rescue false
  end
end