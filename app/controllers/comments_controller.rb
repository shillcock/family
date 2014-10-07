class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      flash[:notice] = "Comment has been created."
    else
      flash[:alert] = "Comment has not been created."
    end

    redirect_to :back
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:content).merge(user: current_user)
    end
end

