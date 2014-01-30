require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'models/test_suite'
require_relative 'models/test'
require_relative 'models/build'

module Squid
  class App < Sinatra::Base

    register Sinatra::ActiveRecordExtension
    set :database_file, '../config/database.yml'

    set :root, File.expand_path('../..', __FILE__)

    get '/' do
      recent_build_ids = TestSuite.recent_build_ids.take(4)
      test_suites = TestSuite.where(build_id: recent_build_ids).all
      @builds = Build.from_test_suites(test_suites)
      erb :index
    end

  end
end
