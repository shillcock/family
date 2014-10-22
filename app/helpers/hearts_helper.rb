module HeartsHelper
  def love_button(lovable)
    link_to [lovable, :hearts], remote: true, method: :post, class: "btn btn-heart" do
      content_tag :span, class: "glyphicon glyphicon-heart-empty" do
        # empty
      end
    end
  end

  def unlove_button(lovable)
    heart = current_user.hearts.where(lovable: lovable).first
    link_to [lovable, heart], remote: true, method: :delete, class: "btn btn-heart" do
      content_tag :span, class: "glyphicon glyphicon-heart" do
        # empty
      end
    end
  end
end

