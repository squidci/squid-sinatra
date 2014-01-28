require './setup'
require './lib/app'
require './lib/api'

run Rack::URLMap.new(
  '/'    => Squid::App.new,
  '/api' => Squid::Api.new
)
