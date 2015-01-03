class SessionsController < ApplicationController
  skip_before_action :authorize_user, only: [:new, :create]

  def new
  end

  def create
    @user = find_user_by_phone_number
    if @user && @user.authenticate(params[:user][:password])
      sign_user_in
      redirect_to root_url, notice: "Signed in!"
    else
      flash.now.alert = "Email or password invalid!"
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url
  end

  private

    def phone_number_param
      @phone_number ||= params[:user][:phone_number].scan(/[0-9]+/).join
    end

    def find_user_by_phone_number
      if phone_number_param.length > 3
        User.where("phone_number LIKE ?", "%#{phone_number_param}").first
      end
    end

    def sign_user_in
      cookies.permanent[:auth_token] = @user.auth_token
      analytics.track_user_sign_in
    end
end

