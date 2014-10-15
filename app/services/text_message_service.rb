class TextMessageService
  def send!(to: nil, message: nil)
    begin
      @message = twilio.messages.create(
        from: default_from,
        to: ENV["OVERRIDES_SMS_TO"] || to,
        body: message
      )
    rescue Twilio::REST::RequestError => error_message
      error_message.to_s
    else
      Rollbar.report_message("Text message sent to #{to}")
      "success"
    end
  end

  private

    def default_from
      ENV["TWILIO_PHONE_NUMBER"]
    end

    def twilio
      @twilio ||= Twilio::REST::Client.new
    end
end

