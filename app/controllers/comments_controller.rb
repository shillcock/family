class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment has been created."
      redirect_to [@post]
    else
      flash[:alert] = "Comment has not been created."
      redirect_to [@post]
    end
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
