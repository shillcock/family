class CommentsController < ApplicationController
  # before_action :set_post, only: [:create]
  # before_action :set_comment, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(comment_params)

    track_comment

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def destroy
    # @comment = @post.comments.find(params[:id])
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user == current_user

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

    # def set_post
    #   @post = Post.find(params[:post_id])
    # end
    #
    # def set_comment
    #   @comment = @post.comments.find(params[:id])
    # end

    def track_comment
      analytics.track_user_post(@comment)
    end

    def comment_params
      params.require(:comment).permit(:content, photos_attributes: [:image]).merge(user_id: current_user.id)
    end
end

