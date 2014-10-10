class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.all.order("updated_at DESC")
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.create!(post_params)

    track_post

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
  end

  def destroy
    @post.destroy if @post.user == current_user

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def track_post
      analytics.track_user_post(@post)
    end

    def post_params
      params.require(:post).permit(:content, photos_attributes: [:image])
    end
end

