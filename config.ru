require './lib/api'

run Rack::URLMap.new(
  '/api' => Squid::Api.new
)
