class ApplicationController < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  helpers do
    def handle_errors(error)
      halt({ code: error.io.status[0], message: error.io.status[1] }.to_json)
    end
  end
end
