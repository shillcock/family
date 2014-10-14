class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception

  private

    def authorize
      unless signed_in?
        flash[:notice] = "Please sign in."
        redirect_to new_session_path
      end
    end

    def signed_in?
      current_user.present?
    end
    helper_method :signed_in?

    def current_user
      @current_user ||= User.find_by(auth_token: cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user

    def analytics
      @analytics ||= Analytics.new(current_user)
    end

    def twilio
      @twilio = Twilio::REST::Client.new
    end
    helper_method :twilio

    def family_phone_number
      @family_phone_number ||= ENV["FAMILY_PHONE_NUMBER"]
    end
    helper_method :family_phone_number
end

