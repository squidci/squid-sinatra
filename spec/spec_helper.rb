ENV['RACK_ENV'] ||= 'test'

require_relative '../setup'
require_relative 'support/coveralls'

require 'rspec'
require 'rack/test'

require 'active_record'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.around do |example|
    ActiveRecord::Base.logger.quietly do
      app.database.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
    end
  end

  config.order = 'random'
end
