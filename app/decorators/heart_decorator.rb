class HeartDecorator < Draper::Decorator
  decorates_association :posts
  decorates_association :photos
  decorates_association :comments
  decorates_association :user

  delegate_all

  def user_avatar(*args)
    user.avatar_url(*args)
  end
end

