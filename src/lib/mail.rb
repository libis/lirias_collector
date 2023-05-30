require 'net/smtp'

module Collector
  class Utils
    def self.mailErrorReport(subject,  report , importance, config)
        to_address = config[:admin_email_to]
        from_address = config[:admin_email_from]
        now = DateTime.now

        message = <<END_OF_MESSAGE
    From: #{from_address}
    To: #{to_address}
    MIME-Version: 1.0
    Content-type: text/html
    Subject: #{subject}
    importance: #{importance}
    Date: #{ now }

    <H1>#{subject}</H1>

    #{report}

END_OF_MESSAGE

    # puts "REMOVE THIS LINE BEFORE GOING TO PRODUCTION "
    
        Net::SMTP.start('smtp.kuleuven.be', 25) do |smtp|
            smtp.send_message message,
            from_address, to_address
        end
    end
  end
end