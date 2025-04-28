class AdminController < ApplicationController
    before_action :require_login
    before_action :require_admin
    def dashboard
        @ride_requests = RideRequest.all.order(created_at: :asc)
    end
end