ENV['RACK_ENV'] ||= 'test'

unless RUBY_PLATFORM =~ /java/
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter 'spec'
  end
end

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
