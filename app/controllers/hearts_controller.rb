class HeartsController < ApplicationController
  before_action :set_lovable, only: [:create, :destroy]
  before_action :set_heart, only: [:destroy]

  def create
    @heart = create_a_heart

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @heart.destroy if @heart.user == current_user

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

    def set_lovable
      @lovable = Post.find_by_id(params[:post_id]) || Comment.find_by_id(params[:comment_id])
    end

    def set_heart
      @heart = @lovable.hearts.find(params[:id])
    end

    def create_a_heart
      @lovable.hearts.create!(user: current_user)
    end
end

