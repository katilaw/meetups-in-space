require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end
end


get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(:event_name)
  erb :'meetups/index'
end

get '/new' do

  current_user

  if @current_user.nil?
    flash[:notice] = "Please sign in"
    redirect '/meetups'
  else
    erb :new
  end
end

get '/meetups/:id' do
  @meetup = Meetup.find(params["id"])
  @creator = @meetup.memberships.where(creator: true).first.user.username
  @members = @meetup.memberships
  erb :show
end

post '/new' do
  event_name = params["event_name"]
  description = params["description"]
  location = params["location"]

  new_meetup = Meetup.create(
    event_name: "#{event_name}",
    description: "#{description}",
    location: "#{location}",
    time: "#{Time.now}"
  )
  if event_name.empty? || description.empty? || location.empty?
    flash[:notice] = "Please fill in the Event Name, Description and Location."
    redirect '/new'
  else
    new_meetup
    Membership.create(creator: true, user_id: current_user.id, meetup_id: new_meetup.id)
    flash[:notice] = "You successfully created a Meetup."
    redirect "/meetups/#{new_meetup.id}"
  end
end

post '/meetups/:id' do
  current_user
  @join_meetup = Meetup.find(params["id"])

  if current_user.nil? == false
    Membership.create(
      user_id: "#{current_user.id}",
      meetup_id: "#{@join_meetup.id}",
      created_at: "#{Time.now}",
      updated_at: "#{Time.now}",
      creator: "#{false}"
    )
    flash[:notice] = "You have successfully joined the Meetup!"

    redirect "/meetups/#{@join_meetup.id}"
  else
    flash[:notice] = "Please sign in."
    
    redirect "/meetups/#{@join_meetup.id}"
  end
end
