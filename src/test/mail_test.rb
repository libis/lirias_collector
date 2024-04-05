# encoding: UTF-8
require 'net/smtp'
require 'date'
require 'time'

to_address = "tom.vanmechelen@kuleuven.be"
from_address = "lirias@libis.kuleuven.be"
smtp_server = "smtp.kuleuven.be"
now = DateTime.now
subject = "TEST lirias collector"

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

Net::SMTP.start(smtp_server, 25, tls_verify: false)  do |smtp|
    smtp.send_message message, from_address , to_address
end
