class SendCommentNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(comment, user)
    message_params = {
      to: user.phone_number,
      message: "##{comment.commentable.id} @#{comment.user.to_param} replied\n#{comment.content}"
    }

    message_params[:media_url] = comment.photos.first.image_url(:medium) if comment.photos.any?

    sms_service.send!(message_params)
  end

  private

    def sms_service
      @sms ||= TextMessageService.new
    end
end

