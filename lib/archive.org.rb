require 'uri'
require 'net/http'
require 'net/ftp'

id = Net::HTTP.get(URI.parse("http://www.archive.org/create.php?identifier=test&xml=1&user=email@example.com"))

"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<result type=\"success\">\n  <message>item is ready</message>\n  <url>ia331432.us.archive.org/test</url>\n</result>"
 
uri = URI.parse("ftp://ia331432.us.archive.org/test")

ftp = Net::FTP.new(uri.host)
ftp.login(user = "email@example.com", passwd = "Password")
ftp.putbinaryfile('/test.jpg')
ftp.close


done = Net::HTTP.get(URI.parse("http://www.archive.org/checkin.php?identifier=test&xml=1&user=email@example.com"))

/checkout.php