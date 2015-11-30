require 'nokogiri'
require 'net/http'
require 'rack'
require 'time'

app = Proc.new do |env|
  if Time.new.getlocal('-03:00').hour < 10
    ['200', {'Content-Type' => 'application/rss+xml'},
     ['']]
  else
    response = Net::HTTP.get('feriadosargentina.com', '/')
    doc = Nokogiri::HTML response
    ['200',
     {'Content-Type' => 'application/rss+xml'},
     [<<RSS
<rss version="2.0">
<channel>
    <title>FeriaFeed</title>
    <link>http://feriadosargentina.com/</link>
    <description>Feriados de Argentina</description>
    <item>
      <title>#{ doc.css('h1').first.content }</title>
      <link>http://www.xul.fr/index.php</link>
      <description>#{ doc.css('h1 + p').first.content }</description>
      <pubDate>#{ Time.parse('10:00 -03:00').utc.rfc2822 }</pubDate>
    </item> 
</channel>
</rss>
RSS
    ]]
  end
end

run app
