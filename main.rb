require 'sinatra/reloader'
require 'sinatra'
require './db_config'
require './models/item'
require './models/user'
require './models/message'
require 'pg'
require 'pry'
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
    if user && user.authenticate(params[:password]) #we're in
    session[:user_id] = user.id
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
  @items = current_user.items
  # @items = Item.find(session[:user_id])  #these items are to be specific to the user
  erb :user_home
end

get '/create_ad' do
  erb :create_ad
end


post '/posted' do
  item = Item.new
  item.name = params[:name]
  item.image_url = params[:image_url]
  item.sold_status = false
  item.category = params[:category]
  item.price= params[:price]
  item.user_id = session[:user_id]
  item.description = params[:description]
  item.save

  erb :posted
end

post '/send_message/:user_id' do

  message = Message.new
  message.content = params[:content]
  message.sender_id = session[:user_id]
  message.receiver_id = params[:user_id]
  message.read_status = false
  message.save

  erb :message_sent
end

get '/messages' do
  #what is the receiver_id. how does it know who is the receiver?
  @users = User.all
  @messages = Message.where(receiver_id: current_user)



  erb :messages

end
