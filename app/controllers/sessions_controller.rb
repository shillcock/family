class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:create]

  def create
    user = User.from_omniauth(auth_params)
    session[:user_id] = user.id if user
    redirect_to url_after_create
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private

    def url_after_create
      analytics.track_user_sign_in
      root_path
    end

    def auth_params
      request.env["omniauth.auth"]
    end
end

