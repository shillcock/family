class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(auth_params)
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private

    def auth_params
      request.env["omniauth.auth"]
    end
end
