class UserAPIController < ApplicationController 

	before do
	    if request.post? or request.patch? or request.put? 
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
				code: 200,
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


# user profile CRUD: 
	patch '/profile' do 

		current_user = User.find_by id: @payload[:userId]

		if current_user 

			current_user.email = @payload[:email]
			current_user.bio = @payload[:bio]

			current_user.save 

			response = {
				success: true,
				code: 200,
				done: true,
				message: "Updated profile of user with userId #{@payload[:id]}"
			}

			response.to_json 

		else 

			response = {
				success: true,
				code: 200,
				done: false,
				message: "Could not find user with id #{@payload[:id]}. No profile updated."
			}

			response.to_json 

		end

	end	


# user CRUD -- change password: 
	patch '/password' do 

		current_user = User.find_by id: @payload[:userId]

		current_pw = @payload[:oldPW]
		new_pw = @payload[:newPW]

		if current_user and user.authenticate(current_pw)

			current_user.password = new_pw 
			current_user.save 
			
			response = {
				success: true,
				code: 200,
				done: true,
				message: "Updated password for user with userId #{@payload[:userId]}"
			}

			response.to_json 

		else 

			response = { 
				success: true,
				code: 200,
				done: false,
				message: "FAILED to update password"
			}

			response.to_json 

		end
	end

# get user info and issues associated with user, by user_id: 
	get '/:id' do 

		# find all user data 
		user = User.find_by id: params[:id] 

		if not user 

			response = {
				success: true,
				code: 200,
				done: false,
				message: "Could not find user with id #{params[:id]}."
			}

			response.to_json 

		else 

			issues = []

			found_issues = Issue.where(owner_id: params[:id]) 

			if found_issues and found_issues.length > 0 
				issues = found_issues 
			end 

			response = {
				success: true,
				code: 200,
				done: true,
				message: "Found user with id #{params[:id]}"
				user: user,
				issues: issues 
			}

			response.to_json
		end
	end

end