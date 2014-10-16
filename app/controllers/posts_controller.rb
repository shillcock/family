class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    #@posts = Post.sorted.page(params[:page]).per(10).decorate
    @posts = Post.order(id: :asc).page(params[:page]).per(10).decorate
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.create!(post_params)

    track_post

    #notify_users

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @post = Post.find(params[:id]).decorate
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

    def notify_users
      #message = twilio.messages.create(
      #  from: twilio_number,
      #  to: '8312776362',
      #  body: "[#{@post.id}] #{@post.content}",
      #  media_url: "http://twilio.com/heart.jpg"
      #)
    end

    def post_params
      params.require(:post).permit(:content, photos_attributes: [:image])
    end
end

