class PostsController < ApplicationController
  def index
    @posts = Post.all.order("created_at DESC")
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post has been created."
      redirect_to posts_path
    else
      flash[:alert] = "Post has not been created."
      redirect_to posts_path
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build(user: current_user)
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end
