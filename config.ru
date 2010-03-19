require 'appengine-rack'

AppEngine::Rack.configure_app(
  :application => 'twitterokinawa',
  :version => 1
)

require 'core'

run Sinatra::Application
