require 'sinatra/base'

class MyApp < Sinatra::Base
  enable :sessions

  # Before Filter
  before do
  end

  get '/' do
    @greeting = "Hi Frank!"
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
