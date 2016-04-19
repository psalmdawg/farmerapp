require 'sinatra/reloader'
require 'sinatra'
require './db_config'
require './models/item'
require './models/user'
require 'pg'

enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

end


after do
  ActiveRecord::Base.connection.close
end

#home list of all items
get '/' do
  @items = Item.all
  erb :index
end

#Individual items
get '/item_info/:id' do
  @item = Item.find(params[:id])
  erb :item_info
end

#to sign in (create new user)
get '/signup' do
    # redirect to 'session/new' if !logged_in?
    erb :signup
end

#sign in / new user
post '/signup' do

  user = User.new
  user.user_name = params[:username]
  user.email = params[:email]
  user.password = params[:password]
  user.save
  redirect to '/'

end

#to log in
get '/session/new' do
   erb :login
end


post '/session' do
    user = User.find_by(email: params[:email])
    #to check if user is there GET THIS EXPLAINED
    if user && user.authenticate(params[:password]) #we're in
    session[:user_id] = user.id
    # @loggedin = session[:username]
      redirect to '/'
    else
      erb :login
    end
end

delete '/session/delete' do
  session[:user_id]=nil
  redirect to('/')
end


get '/donate' do

  erb :donate
end

get '/user_home' do
  erb :user_home
end
