class SendPostNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(post, user)
    message_params = {
      to: user.phone_number,
      message: "P#{post.id} #{post.content}"
    }

    # params[:media_url] = post.photos.first.image_url(:medium) if post.photos.any?

    sms_service.send!(message_params)
  end

  private

  def sms_service
    @sms ||= TextMessageService.new
  end
end

