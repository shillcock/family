class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def index
    @users = User.order(created_at: :asc)
  end

  def show
    @posts = if @user
      @user.posts.sorted.page(params[:page]).per(10)
    else
      []
    end
  end

  private

    def set_user
      t = User.arel_table
      @user = User.where(t[:first_name].matches("%#{params[:id]}")).first
    end
end

