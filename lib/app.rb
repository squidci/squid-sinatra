require 'sinatra/base'
require 'sinatra/partial'
require 'sinatra/activerecord'

require_relative 'models/test_suite'
require_relative 'models/test'
require_relative 'models/build'

module Squid
  class App < Sinatra::Base

    register Sinatra::Partial
    set :partial_template_engine, :erb
    enable :partial_underscores

    register Sinatra::ActiveRecordExtension
    set :database_file, '../config/database.yml'

    set :root, File.expand_path('../..', __FILE__)

    get '/' do
      recent_build_ids = TestSuite.recent_build_ids.take(4)
      test_suites = TestSuite.where(build_id: recent_build_ids).all
      @builds = Build.from_test_suites(test_suites)
      erb :index
    end

    get '/builds/:id' do
      @tests = sort Test.where(build_id: params[:id])
      erb :build
    end

    helpers do

      def sort(tests)
        result = {}

        tests.each do |test|
          desc = test.description.split('<<<|>>>')
          desc = desc.unshift(test.test_group)

          desc.each.with_index.inject(result) do |container, (group, index)|
            container[group] ||= {}

            last_group = desc.length == index + 1
            container[group] = test if last_group

            container[group]
          end
        end

        result
      end

    end

  end
end
