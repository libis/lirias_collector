# encoding: UTF-8
require 'net/smtp'


module Collector
  class Utils
    def self.mailErrorReport(subject,  report , importance, config)
        to_address   = config[:admin_email_to]
        from_address = config[:admin_email_from]
        smtp_server  = config[:smtp_server]
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

        puts "REMOVE THIS LINE BEFORE GOING TO PRODUCTION "
        puts "smtp_server #{smtp_server}"
        Net::SMTP.start(smtp_server, 25, tls_verify: false)  do |smtp|
            smtp.send_message message, from_address, to_address
        end
        
      end
  end
end