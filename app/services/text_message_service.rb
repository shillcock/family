class TextMessageService
  def send!(to: nil, message: nil, media_url: nil)
    to = ENV["OVERRIDES_SMS_TO"] || to
    message = message.truncate(1500, omission: "... (continued)")

    begin
      @text_message = if media_url
        send_mms(to, message, media_url)
      else
        send_sms(to, message)
      end
    rescue Twilio::REST::RequestError => error_message
      Rollbar.error(error_message)
      error_message.to_s
    end
  end

  private
    def send_sms(to, message)
      twilio.messages.create(from: default_from, to: to, body: message)
    end

    def send_mms(to, message, media_url)
      twilio.messages.create(from: default_from, to: to, body: message, media_url: media_url)
    end

    def default_from
      ENV["TWILIO_PHONE_NUMBER"]
    end

    def twilio
      @twilio ||= Twilio::REST::Client.new
    end
end

