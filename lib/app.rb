require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'models/build'
require_relative 'models/test'

module Squid
  class App < Sinatra::Base

    register Sinatra::ActiveRecordExtension
    set :database_file, '../config/database.yml'

    set :root, File.expand_path('../..', __FILE__)

    get '/' do
      @builds = Build.recent.take(5)
      erb :index
    end

  end
end
