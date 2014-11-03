class SessionsController < ApplicationController
  skip_before_action :authorize_user, only: [:new, :create, :status]
  before_action :set_user, only: [:status]

  def new
  end

  def create
    @user = find_user_by_phone_number

    if @user
      SendSmsConfirmationJob.perform_later(@user)
      session[:user_id] = @user.id
      render :auth
    else
      flash.now[:error] = "Hi there stranger, you are beautiful!"
      render :new
    end
  end

  def status
    render json: { status: get_status }
  end

  def destroy
    session[:user_id] = nil
    cookies[:auth_token] = nil
    redirect_to root_url
  end

  private

    def set_user
      @user = User.find(session[:user_id])
    end

    def phone_number_param
      @phone_number ||= params[:user][:phone_number].scan(/[0-9]+/).join
    end

    def find_user_by_phone_number
      if phone_number_param.length > 3
        User.where("phone_number LIKE ?", "%#{phone_number_param}").first
      end
    end

    def get_status
      if @user.sms_confirmed?
        sign_user_in
        "confirmed"
      else
        "pending"
      end
    end

    def sign_user_in
      cookies.permanent[:auth_token] = @user.auth_token
      analytics.track_user_sign_in
    end
end

