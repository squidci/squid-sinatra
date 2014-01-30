require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'models/test_suite'
require_relative 'models/test'

module Squid
  class Api < Sinatra::Base

    register Sinatra::ActiveRecordExtension
    set :database_file, '../config/database.yml'

    set :root, File.expand_path('../..', __FILE__)

    before do
      @json = parse_json_input
      @build_id = @json['build_id']
    end

    post '/test-suite-started' do
      create_test_suite @json.merge(status: 'started')
      200
    end

    post '/test-suite-finished' do
      update_test_suite @json
      200
    end

    post '/test-passed' do
      database.transaction do
        create_test @json.merge(status: 'passed')
        increment_test_suite :passed_count
      end

      200
    end

    post '/test-failed' do
      database.transaction do
        create_test @json.merge(status: 'failed')
        increment_test_suite :failed_count
      end

      200
    end

    post '/test-pending' do
      database.transaction do
        create_test @json.merge(status: 'pending')
        increment_test_suite :pending_count
      end

      200
    end

    helpers do

      def create_test(data)
        Test.create(data)
      end

      def create_test_suite(data)
        TestSuite.create(data)
      end

      def update_test_suite(data)
        started_at = data['started_at']
        test_suite = TestSuite.where(build_id: @build_id, started_at: started_at).first

        if test_suite
          if test_suite.update(data)
            puts "Updated TestSuite with ID #{@build_id} started at #{started_at}"
          else
            puts "Failed to update TestSuite with ID #{@build_id} started at #{started_at}"
          end
        else
          puts "Failed to find TestSuite to update with ID #{@build_id} started at #{started_at}"
        end
      end

      def increment_test_suite(attribute)
        started_at = @json['test_suite_started_at']
        test_suite = TestSuite.where(build_id: @build_id, started_at: started_at).first

        if test_suite
          counters = { attribute => 1, :total_count => 1 }
          TestSuite.update_counters(test_suite.id, counters)

          puts "Incremented :#{attribute} for TestSuite with ID #{@build_id} started at #{started_at}"
        else
          puts "Failed to find TestSuite with ID #{@build_id} started at #{started_at} to increment :#{attribute}"
        end
      end

      def parse_json_input
        input = request.env['rack.input'].read
        input.empty? ? {} : JSON.parse(input)
      end

    end

  end
end
