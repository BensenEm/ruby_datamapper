require 'sinatra/base'

class MyApp < Sinatra::Base
  enable :sessions



  # Before Filter
  before do
    session['counter'] ||= 0 # Setzt den Session-Counter auf 0, wenn er `nil` war
    session['counter'] += 1  # Inkrementiert den Counter um 1
    @count=session['counter']
   end
=begin
  get '/:value' do
    session['value'] = params['value']
  end
=end



  get '/' do
    @greeting="Welcome Guys... "
    erb :index
  end

  get "/index.html" do
    @greeting="...let's do it!"
    erb :index
  end

  get "/contact.html" do
    erb :contact
  end

  post "/sendto" do
    @Name= params[:name]
    @Email= params[:email]
    @Message= params[:message]
    erb :sendto
  end


  get "/imprint.html" do
    erb :imprint
  end

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
    end

  end
  get "/admin.html" do
    protected!
      erb :admin
  end
# start the server if ruby file executed directly
run! if app_file == $0
end
