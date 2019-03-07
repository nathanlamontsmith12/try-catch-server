class UserController < ApplicationController

	# before do
	#     if request.post?
	# 		payload_body = request.body.read
	# 		@payload = JSON.parse(payload_body).symbolize_keys
	# 		puts "---------> Here's our payload"
	# 		pp @payload

	# 	end
	#  	end



	# before ['/new', '/submit', '/destroy', '/find', '/display'] do
	# 	if not (session[:logged_in] and session[:is_admin])
	# 		session[:message] = "You must be logged in as an administrator to do that!"
	# 		redirect '/admin/login'
	# 	end
	# end

	get '/test' do
		"User controller hooked up."
	end

	# post '/register' do
	# 	puts "hitting register route"

	# 	user = User.find_by username: params[:username]

	# 	if not user
	# 		user = User.new
	# 		user.username = params[:username]
	# 		user.password = params[:password]
	# 		user.is_admin = params[:is_admin]
	# 		user.save

	# 		session[:logged_in] = true
	# 		session[:username] = user.username

	# 		session[:message] = {
	# 			success: true,
	# 			status: "good",
	# 			message: "#{user.username} successfully created and loggin in."
	# 		}

	# 		redirect '/user/home'

	# 	else
	# 		session[:message] = {
	# 			success: true,
	# 			status: "bad",
	# 			message: "Sorry, username #{params[:username]} is taken."
	# 		}

	# 		redirect '/user/register'
	# 	end
	# end

		
	# get '/login' do
	# 	"Home/Login route at Usercontroller"
	# 	erb :login
	# end

	# post '/login' do
	# 	puts "Login POST route <hit class=""></hit>"
	# 	puts params

	# 	user = User.find_by username: params[:username]

	# 	pw = params[:password]

	# 	if user and user.authenticate(pw)
	# 		session[:logged_in] = true
	# 		session[:username] = user.username
	# 		session[:message] = {
	# 			success: true,
	# 			status: "good",
	# 			message: "Logged in as #{user.username}"
	# 		}
	# 		redirect 'user/home'
	# 	else
	# 		session[:message] = {
	# 			success: false,
	# 			status: "bad",
	# 			message: "Shucks, username or password incorrect."
	# 		}
	# 		redirect 'user/login'
	# 	end
	# end

	# get '/logout' do
	# 	username = session[:username]

	# 	session.destroy
	# 	session[:message] = {
	# 		success: true,
	# 		status: "neutral",
	# 		message: "User #{username} logged out."
	# 	}
	# 	redirect '/'
	# end
end