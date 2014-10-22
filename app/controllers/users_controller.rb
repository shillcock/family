class UsersController < ApplicationController
  def show
    t = User.arel_table
    @user = User.where(t[:first_name].matches("%#{params[:id]}")).first
    @posts = if @user
      @user.posts.sorted.page(params[:page]).per(10)
    else
      []
    end
  end
end

