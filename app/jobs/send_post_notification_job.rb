class SendPostNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(post, user)
    message = "##{post.id} @#{post.user.to_param} posted\n#{post.content}"
    media = post.photos.map {|photo| photo.image_url(:medium)} if post.photos.any? && user.can_receive_mms?

    TextMessageService.new(to: user.phone_number, message: message, media: media).send!
  end
end

