class UserDecorator < Draper::Decorator
  decorates_association :posts
  decorates_association :comments
  decorates_association :photos
  decorates_association :hearts

  delegate_all

  def name
    model.first_name
  end

  def avatar_url(size = 80)
    h.gravatar_image_url(object.email, size)
  end

  def loves?(lovable)
    lovable.hearts.exists?(user: object)
  end
end

