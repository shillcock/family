class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.sorted.page(params[:page]).per(10)
    #@posts = Post.order(id: :asc).page(params[:page]).page(5)
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.photos.each {|photo| photo.user = current_user}

    if @post.save
      @post.send_notifications!
      track_post
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post.destroy if @post.user == current_user

    respond_to do |format|
      format.html { redirect_to posts_path }
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

