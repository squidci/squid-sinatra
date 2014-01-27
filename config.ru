require './lib/api'
require_relative 'setup'

run Rack::URLMap.new(
  '/api' => Squid::Api.new
)
