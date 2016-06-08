require 'sinatra/base'
require './datamapper'

class MyApp < Sinatra::Base
  enable :sessions

  configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end



  # Before Filter
  before do
    session['counter'] ||= 0 # Setzt den Session-Counter auf 0, wenn er `nil` war
    session['counter'] += 1  # Inkrementiert den Counter um 1
    @count=session['counter']
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

=begin
  get '/:value' do
    session['value'] = params['value']
  end
=end



  get '/' do
    @greeting="Welcome Braaa... "
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
    item=ContactRequest.create(name: params['name'], email: params['email'], message: params['message'])
    erb :sendto

  end



  get "/imprint.html" do
    erb :imprint
  end




  get "/admin.html" do
    protected!
      erb :admin
  end

  get "/admin/contact-requests.html" do
    protected!
    @all_contacts=ContactRequest.all
    erb :contact_requests
  end

  get "/admin/contact-requests/:id.html" do |id|
    thiscontact=ContactRequest.get!(id)
    @Name=thiscontact.name
    @Email=thiscontact.email
    @Message=thiscontact.message
    erb :showcontact
  end

  get "/admin/contact-requests/:id/edit.html" do |id|
    @posst=ContactRequest.get!(id)
    erb :editcontact
  end

  post "/updateContact/:id" do |id|
    thiscontact=ContactRequest.get!(id)
    thiscontact.update(name: params['name'], email: params['email'], message: params['message'])
    @Name=thiscontact.name
    @Email=thiscontact.email
    @Message=thiscontact.message
    erb :showcontact
  end

  get "/admin/contact-requests/:id/delete.html" do |id|
    thiscontact=ContactRequest.get!(id)
    thiscontact.destroy
    erb :admin
  end

# start the server if ruby file executed directly
run! if app_file == $0
end
end
