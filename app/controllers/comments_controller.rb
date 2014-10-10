class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.create!(comment_params)

    track_comment

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @comment.destroy if @comment.user == current_user

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def track_comment
      analytics.track_user_post(@comment)
    end

    def comment_params
      params.require(:comment).permit(:content).merge(user_id: current_user.id)
    end
end

