class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.order(created_at: :asc)
  end

  def show
    @posts = if @user
      @user.posts.sort_by_created_at.page(params[:page]).per(10)
    else
      []
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: "Account has been updated."
    else
      render :edit
    end
  end

  private

    def set_user
      t = User.arel_table
      @user = User.where(t[:first_name].matches("%#{params[:id]}")).first
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end

