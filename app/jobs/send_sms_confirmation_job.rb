class SendSmsConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.generate_sms_token!

    TextMessageService.new(
      to: user.phone_number,
      message: "Hi #{user.first_name}, please reply with the following code: #{user.sms_token}"
    ).send!
  end
end

