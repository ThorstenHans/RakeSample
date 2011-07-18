require 'net/smtp'

class DotNetRocksMailer 

  def self.send_email(from, to, subject, message, attachmentFileName, mailServer)
		filename = attachmentFileName 
		filecontent = File.read(filename)
		fileNameOnly = File.basename(attachmentFileName)
		encodedcontent = [filecontent].pack("m")   # base64
	marker = "AUNIQUEMARKER"
	body =<<EOF
This is a test email to send an attachement.
EOF

# Define the main headers.
part1 =<<EOF
From: DataOne Build Master <th@dataone.de>
To: #{to} 
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

# Define the message action
part2 =<<EOF
Content-Type: text/html
Content-Transfer-Encoding:8bit

#{message}
--#{marker}
EOF
# Define the attachment section
part3 =<<EOF
Content-Type: multipart/mixed; name=\"#{fileNameOnly}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{fileNameOnly}"

#{encodedcontent}
--#{marker}--
EOF
	mailtext = part1 + part2 + part3
	#http://www.ruby-doc.org/stdlib/libdoc/net/smtp/rdoc/classes/Net/SMTP.html
	Net::SMTP.start(mailServer) do |smtp|
		smtp.send_message mailtext, from, to
	end
  end
end
