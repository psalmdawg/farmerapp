require 'sinatra/reloader'
require 'sinatra'
require './db_config'
require './models/item'
require 'pg'

enable :sessions

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

    # @items = DishType.all
  erb :signup
end

#sign in / new user
post '/signup' do

  user = User.new
  user.user_name = params[:username]
  user.email = params[:email]
  user.password_digest = params[:password]
  redirect to '/'

end
