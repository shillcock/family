class SendCommentNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(comment, user)
    message = "##{comment.commentable.id} @#{comment.user.to_param} replied\n#{comment.content}"
    media = comment.photos.map {|photo| photo.image_url(:medium)} if comment.photos.any?

    TextMessageService.new(to: user.phone_number, message: message, media: media).send!
  end
end

