# encoding: UTF-8
require 'net/smtp'
require 'date'
require 'mail'

$LOAD_PATH << "./lib" << "./"

to_address = "tom.vanmechelen@kuleuven.be"
from_address = "test@libis.kuleuven.be"
now = DateTime.now
subject = "TEST Lirias collector"

puts "We gaan proberen te versturen"

message = <<END_OF_MESSAGE
From: #{from_address}
To: #{to_address}
MIME-Version: 1.0
Content-type: text/html
Subject: #{subject}

Date: #{ now }

<H1>#{subject}</H1>

BLALALBALBLABLBLBL L LLBLBLBLABALBAL  blbBLALBALBALBABL

END_OF_MESSAGE

Mail.defaults do
    delivery_method :smtp, address: "smtp.kuleuven.be", port: 25
end

mail = Mail.new do
    from    'tom.vanmechelen@kuleuven.be'
    to      'tom.vanmechelen@kuleuven.be'
    subject 'This is a test email'
    body     'message'
end

mail.to_s

pp "has been send"