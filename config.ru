require './lib/api'

run Rack::URLMap.new(
  '/api' => CI::Api.new
)
