class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception

  private

    def authorize
      unless signed_in?
        flash[:notice] = "Please sign in."
        redirect_to sign_in_path
      end
    end

    def signed_in?
      current_user ? true : false
    end
    helper_method :signed_in?

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
end

