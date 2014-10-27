class TextMessageService
  def send!(to: nil, message: nil)
    @to = ENV["OVERRIDES_SMS_TO"] || to
    @message = if ENV["OVERRIDES_SMS_TO"]
      "#{to} - #{message}"
    else
      message
    end

    begin
      @sms_message = twilio.messages.create(
          from: default_from,
          to: @to,
          body: @message
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

