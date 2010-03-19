require 'appengine-rack'

AppEngine::Rack.configure_app(
  :application => 'twitterokinawa',
  :version => 1
)

require 'core'

configure :development do
  class Sinatra::Reloader < ::Rack::Reloader
    def safe_load(file, mtime, stderr = $stderr)
      ::Sinatra::Application.reset!
      super
    end
  end
  use Sinatra::Reloader
end

run Sinatra::Application
