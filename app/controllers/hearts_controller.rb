class HeartsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find_by_id(params[:comment_id])

    @heart = build_a_heart

    if @heart.save
      flash[:notice] = "Heart was successfully created."
    else
      flash[:error] = "Heart was not created."
    end

    redirect_to :back
  end

  private

    def build_a_heart
      target = @comment || @post
      target.hearts.build(user: current_user)
    end
end
