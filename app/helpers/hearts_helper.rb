module HeartsHelper
  def love_button(lovable)
    button_to 'Love', [lovable, :hearts], remote: true
  end

  def unlove_button(lovable)
    heart = current_user.hearts.where(lovable: lovable).first
    button_to 'UnLove', [lovable, heart], remote: true, method: :delete
  end
end

