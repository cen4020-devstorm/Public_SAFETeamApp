class PagesController < ApplicationController
    def ride_redirect
        if current_user&.admin?
            redirect_to admin_dashboard_path and return
        end
        now = Time.current.in_time_zone("Eastern Time (US & Canada)")

        if within_op_hours(now)
        redirect_to login_path
        else
        redirect_to outside_hours_path
        end
    end

    private

    def within_op_hours(time)
    allowed_days = [0, 1, 2, 3, 4]
    current_day = time.wday
    current_time = time.strftime("%H:%M")

    if allowed_days.include?(current_day)
        return true if current_time > "18:30" || current_time < "02:00"
    end
    if current_day == 5 && current_time < "02:00"
        return true
    end

    return false
    end
end
