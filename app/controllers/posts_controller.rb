class PostsController < ApplicationController
  def index
    @posts = Post.all.order("updated_at DESC")
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.create!(post_params)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end
