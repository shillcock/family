class HeartsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find_by_id(params[:comment_id])

    @heart = create_a_heart

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

    def create_a_heart
      target = @comment || @post
      target.hearts.create!(user: current_user)
    end
end
