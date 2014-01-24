require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'models/build'
require_relative 'models/test'

require_relative '../setup'

module CI
  class Api < Sinatra::Base

    register Sinatra::ActiveRecordExtension

    set :database_file, '../config/database.yml'

    before do
      @json = parse_json_input
      @build_id = @json['build_id']
    end

    post '/test-suite-started' do
      upsert_build @build_id, @json.merge(status: 'started')
      200
    end

    post '/test-suite-finished' do
      upsert_build @build_id, @json
      200
    end

    post '/test-passed' do
      database.transaction do
        create_test @json.merge(status: 'passed')
        increment_build @build_id, :passed_count
      end

      200
    end

    post '/test-failed' do
      database.transaction do
        create_test @json.merge(status: 'failed')
        increment_build @build_id, :failed_count
      end

      200
    end

    post '/test-pending' do
      database.transaction do
        create_test @json.merge(status: 'pending')
        increment_build @build_id, :pending_count
      end

      200
    end

    helpers do

      def create_test(data)
        Test.create(data)
      end

      def upsert_build(build_id, data)
        build = Build.where(build_id: build_id).first_or_initialize
        build.update_attributes(data)
      end

      def increment_build(build_id, attribute)
        build = Build.where(build_id: build_id).first
        Build.increment_counter(attribute , build.id) if build
      end

      def parse_json_input
        input = request.env['rack.input'].read
        input.empty? ? {} : JSON.parse(input)
      end

    end

  end
end
