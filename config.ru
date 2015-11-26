require 'nokogiri'
require 'net/http'
require 'rack'

app = Proc.new do |env|
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
    </item> 
</channel>
</rss>
RSS
  ]]
end

run app

puts 'App started, visit http://feriafeed.herokuapp.com/feed.rss'
