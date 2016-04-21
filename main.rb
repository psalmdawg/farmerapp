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

    erb :signup
end

#sign in / new user
post '/signup' do




  user = User.new
  user.user_name = params[:username]
  user.email = params[:email]
  user.password = params[:pass2]
  user.save

  username = params[:username]
  email = params[:email]

  File.open("emails.csv", "a+") do |f|
    f.write "#{Time.now},#{username},#{email}\n"
  end
  redirect to '/session/new'

end

delete '/remove_profile' do

  @messages = Message.where(receiver_id: current_user.id)
  @messages.each do |message|
    message.delete
  end
  @items = Item.where(user_id: current_user.id)
  @items.each do |item|
    item.delete
  end

  messages = params[:messages]
  items = params[:items]
  user = current_user
  user.delete
  redirect to '/please_dont_leave_me'
end

get '/please_dont_leave_me' do
  "sorry you are leaving, sign up again for full free access, anytime!"
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
#to log out
delete '/session/delete' do
  session[:user_id]=nil
  redirect to('/')
end

get '/donate' do
  erb :donate
end

get '/user_home' do
  @items = current_user.items
  @name = current_user.user_name
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

# <form action="/item_info/<%= item.id %>"
#to delete an item for sale

# Item.delete(Item.find(:id))

delete '/item_info/:id' do
  item = Item.find(params[:id])
  item.delete
  redirect "/user_home"
end

#delete a message

delete '/messages/:id' do
  message = Message.find(params[:id])
  message.delete
  redirect "/messages"
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


get '/reply' do

  @reciever = params[:receiver]
  erb :reply
end

post '/replied' do

  message = Message.new
  message.content = params[:content]
  message.sender_id = session[:user_id]
  message.receiver_id = params[:receiver]
  message.read_status = false
  message.save
  erb :replied
end

get '/remove' do
  erb :remove_profile
end
