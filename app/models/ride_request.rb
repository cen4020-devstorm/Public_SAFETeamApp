# class RideRequest < ApplicationRecord
#     validates :name, :phone, :location, :destination, presence: true
#     validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
#   end

class RideRequest < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates :name, :phone, :location, :destination, presence: true
  validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
end
  
