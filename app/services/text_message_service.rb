class TextMessageService
  def initialize(to: nil, message: "", media: nil)
    @to = to
    @body = message
    @media = media
  end

  def send!
    rescue_send_execption do
      if @media.try(:any?)
        send_mms
      else
        send_sms
      end
    end
  end

  private

    def rescue_send_execption
      yield
    rescue Twilio::REST::RequestError => error_message
      Rollbar.error(error_message)
      nil
    end

    def to
      ENV["OVERRIDES_SMS_TO"] || @to
    end

    def body
      @truncated_body ||= @body.truncate(1500, omission: "... (continued)") if @body
    end

    def media
      @media
    end

    def from
      ENV["TWILIO_PHONE_NUMBER"]
    end

    def send_sms
      @sms = twilio.messages.create(from: from, to: to, body: body)
      @sms.sid
    end

    def send_mms
      @mms = twilio.messages.create(from: from, to: to, body: body, media_url: media)
      @mms.sid
    end

    def twilio
      @twilio ||= Twilio::REST::Client.new
    end
end

