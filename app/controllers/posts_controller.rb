class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    set_posts
    @post = current_user.posts.build
  end

  def create
    build_post

    if @post.save
      @post.send_notifications!
      track_post
    end

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  def show
    # empty
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

    def set_posts
      @posts = if params[:sort_by] == "created_at"
        Post.sort_by_created_at.page(params[:page]).per(10)
      else
        Post.sort_by_updated_at.page(params[:page]).per(10)
      end

      authorize @posts
    end

    def set_post
      @post = Post.find(params[:id])
      authorize @post
    end

    def build_post
      @post = current_user.posts.build(post_params)
      @post.photos.each {|photo| photo.user = current_user}
      authorize @post
    end

    def track_post
      analytics.track_user_post(@post)
    end

    def post_params
      params.require(:post).permit(:content, photos_attributes: [:image])
    end
end

