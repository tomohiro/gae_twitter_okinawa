require 'rubygems'
require 'sinatra'
require 'appengine-apis/urlfetch'

get '/' do
  response = Net::HTTP.start('kotatsumikan.ddo.jp').get('/cgi-bin/twitterokinawa.cgi')
  response.body
end
