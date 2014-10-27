class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    #@comment.photos.each {|photo| photo.user = current_user}

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
    @comment = Comment.find(params[:id])
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user == current_user

    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

    def track_comment
      analytics.track_user_post(@comment)
    end

    def comment_params
      params.require(:comment).permit(:content, photos_attributes: [:image]).merge(user_id: current_user.id)
    end
end

