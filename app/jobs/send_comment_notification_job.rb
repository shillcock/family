class SendCommentNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(comment, user)
    @comment = comment
    @user = user

    if ok_to_notify_user?
      notify_user
      @user.last_notification_sent_at = Time.zone.now
      @user.save
    else
      Rollbar.info("Skipped notification, throttling message to #{@user.first_name}")
    end
  end

  private

    def message
      "##{@comment.commentable.id} @#{@comment.user.to_param} replied\n#{@comment.content}"
    end

    def media
      @comment.photos.map {|photo| photo.image_url(:medium)}
    end

    def ok_to_notify_user?
      if @user.throttle_notifications?
        (@user.last_notification_sent_at + 5.minutes) < Time.zone.now
      else
        true
      end
    end

    def notify_user
      TextMessageService.new(to: @user.phone_number, message: message, media: media).send!
    end
end

