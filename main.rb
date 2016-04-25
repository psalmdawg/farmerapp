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

@emails = []
users = User.all
users.each do |user|
  @emails.push(user.email)
end
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

  #email checker
  emailCheck = []
  users=User.all
  users.each do |u|
  emailCheck.push(u.email)
  end
if emailCheck.include? params[:email]

      @email_alert = "I warned you! this email is already taken, if its yours maybe you can login already"
      erb  :signup
    else

      File.open("emails.csv", "a+") do |f|
        f.write "#{Time.now},#{username},#{email}\n"
      redirect to '/session/new'
    end

    # >> ['Cat', 'Dog', 'Bird'].include? 'Dog'
    # => true

end

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

    user = current_user
    user.delete
  redirect to '/please_dont_leave_me'
end

get '/please_dont_leave_me' do
  "sorry you are leaving, sign up again for full free access, anytime!
</br><a href ='/'>Home</a>"
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

#home page
get '/user_home' do
  @items = current_user.items
  @name = current_user.user_name
  # @items = Item.find(session[:user_id])
  erb :user_home
end


get '/create_ad' do
  erb :create_ad
end

#post an item
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

#delete an item

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

#send a message (on ITEM INFO PAGE)
post '/send_message/:user_id' do
  message = Message.new
  message.content = params[:content]
  message.sender_id = session[:user_id]
  message.receiver_id = params[:user_id]
  message.read_status = false
  message.related_item_id = params[:related]
  message.save
  erb :message_sent
end

#send a new mesage
post '/new_message' do
  message = Message.new
  item=params[:related]
  related = Item.find_by name: item
  name = params[:recipient]
  recipient = User.find_by user_name: name
  message.content = params[:content]
  message.receiver_id = recipient.id
  message.content = params[:content]
  message.sender_id = session[:user_id]
  message.related_item_id = related.id
  message.read_status = false
  message.save
  erb :message_sent

end

#Displays all current messages
get '/messages' do

  @users = User.all
  @messages = Message.where(receiver_id: current_user)
  @beenread = Message.where(receiver_id: current_user)
  message = Message.where(receiver_id: current_user)

  message.each do |m|
    m.read_status = true
    m.save
  end


  # @beanread = beenread
  if  @messages == []
    @noMsg  = "You have no messages"
  end
  erb :messages
end

#SENDING REPLY
post '/reply' do
  @forward_senderID = session[:user_id]
  @forward_receiverID = params[:receiver]
  @forward_related_itemID = params[:related]
  erb :reply
end

#actually sends the message
post '/replied' do
  message = Message.new
  message.sender_id = session[:user_id]
  message.receiver_id = params[:receiver]
  message.related_item_id = params[:related_item]
  message.content = params[:content]
  message.read_status = false
  message.save
  erb :replied
end

get '/remove' do
  erb :remove_profile
end

get '/contact' do
  "Hey! Come round for a beer sometime,
  <a href= '/'>get me outta here</a>"
end

get '/todo' do
  erb :todo
end

get '/messages' do
  "not yet made this page"

  "<a href= '/'>get me outta here</a>"
end

get '/new_message' do


# @user = User.where(id: 40)
  @users = User.all
  @items = Item.all

erb :new_message
end
