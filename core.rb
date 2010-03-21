require 'rubygems'
require 'sinatra'
require 'appengine-apis/urlfetch'

$KCODE = 'u'

template :layout do
<<-LAYOUT
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="Content-Script-Type" content="text/javascript" />
        <meta http-equiv="Content-Style-Type" content="text/css" />
        <meta name="viewport" content="width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes /">
        <link rel="stylesheet" type="text/css" href="/styles/reset-min.css" />
        <link rel="stylesheet" type="text/css" href="/styles/fonts-min.css" /> 
        <link rel="stylesheet" type="text/css" href="/styles/design.css" /> 
        <title>TwitterOkinawa IRC Logs Viewer</title>
    </head>
    <body>
      <%= yield %>
    </body>
</html>
LAYOUT
end

get '/*' do
  @keywords = params[:splat].to_s.split('-') 
  erb %{
  <ul>#{irc_logs.to_s}</ul>
  }
end

def irc_logs
  response = Net::HTTP.start('kotatsumikan.ddo.jp').get('/cgi-bin/twitterokinawa.cgi')
  logs = []
  
  response.body.to_a[0..50].each do |line|
    case line
    when /^\(.+?\)/
      logs.push notice(line)
    when /^&lt;.+?&gt;/
      logs.push message(line)
    end
  end

  logs
end

def notice(line)
  line[/^\(#(.+?)\) (.+) (.+?$)/]
  nick, content, timestamp = $1, $2, $3

  list_template(:notice, nick, content, timestamp)
end

def message(line)
  line[/^&lt;#(.+?)&gt; (.+) (.+$)/]
  nick, content, timestamp = $1, $2, $3

  list_template(:message, nick, content, timestamp)
end

def list_template(type, nick, content, timestamp)
  type = "#{type} #{hilight(content)}"
  <<-LIST
<li class="#{type}" class="">
<span class="nick">#{nick}:</span>
<span class="content">#{content}</span>
</li>
  LIST
end

def hilight(content)
  hilight = ''
  @keywords.each do |keyword|
    hilight = 'hilight' if content =~ Regexp.new(keyword)
  end
  hilight
end
