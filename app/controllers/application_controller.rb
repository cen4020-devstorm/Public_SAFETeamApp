class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def require_admin
    unless admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end

