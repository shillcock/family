class CommentsController < ApplicationController
  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:show, :destroy]

  def create
    build_comment

    if @comment.save
      @comment.send_notifications!
      track_comment
    end

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  def show
  end

  def destroy
    commentable = @comment.commentable
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to [commentable]}
      format.js
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
      authorize @comment
    end

    def build_comment
      @comment = @post.comments.build(comment_params)
      @comment.photos.each {|photo| photo.user = current_user}
      authorize @comment
    end

    def track_comment
      analytics.track_user_post(@comment)
    end

    def comment_params
      params.require(:comment).permit(:content, photos_attributes: [:image]).merge(user_id: current_user.id)
    end
end

