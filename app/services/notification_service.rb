# app/services/notification_service.rb
class NotificationService
    def self.send_text(phone_number, message)
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: phone_number,
        body: message
      )
    end
  end
  