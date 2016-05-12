require 'sinatra/base'

class MyApp < Sinatra::Base
  enable :sessions

  # Before Filter
  before do
    session['counter'] ||= 0 # Setzt den Session-Counter auf 0, wenn er `nil` war
    session['counter'] += 1  # Inkrementiert den Counter um 1
   end

  get '/:value' do
    session['value'] = params['value']
  end

  get '/' do
    @greeting="Hi. Dies ist die Sitzungsnummer: "
    erb :index
end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
