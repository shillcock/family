class CommsController < ApplicationController
  skip_before_action :authorize, only: [:voice, :sms]
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:voice, :sms]
  after_filter :set_header

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hello #{user.firs_name}!", voice:"alice"
      r.Play "http://linode.rabasa.com/cantina.mp3"
    end

    render_twiml response
  end

  def sms
    if @user.sms_confirmed?
      create_post_from_sms
    elsif confirm_user
      send_welcome_response
    end
 end

  private
    def set_user
      unless @user = User.find_by(phone_number: params["From"])
        head :not_found
      end
    end

    def confirm_user
      if @user.sms_token && params["Body"].include?(@user.sms_token)
        @user.update_attributes(sms_confirmed_at: Time.zone.now, sms_token: nil)
      else
        false
      end
    end

    def create_post_from_sms
      post = SmsPost.new(@user, params)
      if post.save
        post.send_notifications!
        head :ok
      else
        head :bad_request
      end
    end

    def send_welcome_message
      response = Twilio::TwiML::Response.new do |r|
        r.Message "Thanks #{@user.first_name}, welcome to the family :)"
      end

      render_twiml response
    end

    def set_header
      response.headers["Content-Type"] = "text/xml"
    end

    def render_twiml(response)
      render text: response.text
    end
end

