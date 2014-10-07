class PostsController < ApplicationController
  def index
    @posts = Post.all.order("updated_at DESC")
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post was successfully created."
    else
      flash[:alert] = "Post was not created."
    end

    redirect_to :back
  end

  def show
    @post = Post.find(params[:id])
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end
