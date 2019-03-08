class UserAPIController < ApplicationController 

	before do
	    if request.post?
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload

		end
  	end

# register user / creat account route: 
	post '/' do 
		puts "Hitting creat accout route"

		user = User.find_by username: @payload[:username]

		if not user 

			user = User.new 

			user.username = @payload[:username]
			user.password = @payload[:password]
			user.email = @payload[:email]
			user.reg_time = @payload[:regTime]

			user.save 

			session[:logged_in] = true
			session[:username] = user.username
			session[:is_admin] = user.is_admin 

			response = {
				success: true,
				code: 201,
				done: true,
				login: true,
				message: "User #{user.username} created",
				username: user.username,
				userId: user.id,
				reg_time: user.reg_time
			}

			response.to_json 

		else 
			response = {
				success: true,
				code: 200,
				done: false,
				login: false,
				message: "Username taken"
			}

			response.to_json 

		end
	end

# login user route: 
	post '/login' do 
		puts "Hitting login route"

		user = User.find_by username: @payload[:username]
		pw = @payload[:password]

		if user and user.authenticate(pw)

			session[:logged_in] = true
			session[:username] = user.username
			session[:is_admin] = user.is_admin 

			response = {
				success: true,
				code: 201,
				done: true,
				message: "User #{user.username} logged in",
				login: true,
				username: user.username,
				userId: user.id,
				reg_time: user.reg_time,
				is_admin: user.is_admin 
			}

			response.to_json 

		else 

			response = {
				success: true,
				code: 200,
				done: false,
				message: "wrong username or password",
				login: false
			}

			response.to_json 

		end
	end


# log out user route 
	get '/logout' do 

		username = session[:username]

		session.destroy 

		response = {
			success: true,
			code: 200,
			done: true,
			message: "#{username} logged out"
		}

		response.to_json 

	end

end