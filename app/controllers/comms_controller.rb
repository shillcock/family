class CommsController < ApplicationController
  skip_before_action :authorize_user, only: [:voice, :sms]
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:voice, :sms]
  after_filter :set_header

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hello #{@user.first_name}, have a terrific day.", voice:"alice"
      r.Play "http://linode.rabasa.com/cantina.mp3"
    end

    render_twiml response
  end

  def sms
    return head :not_found unless @user

    post = SmsPost.new(@user, params)
    if post.save
      post.send_notifications!
      head :ok
    else
      head :bad_request
    end
 end

 private
    def set_user
      @user = User.find_by(phone_number: params["From"])
    end

    def set_header
      response.headers["Content-Type"] = "text/xml"
    end

    def render_twiml(response)
      render text: response.text
    end
end

