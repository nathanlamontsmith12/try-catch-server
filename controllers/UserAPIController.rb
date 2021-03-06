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


# non-login -- authenticate user's password 
	post '/check' do 

		puts "check user route hit"

		user = User.find_by id: @payload[:user_id]
		pw = @payload[:password]

		if user and user.authenticate(pw) 

			response = {
				success: true,
				code: 200,
				done: true,
				message: "Checks out!"
			}

			response.to_json

		else 

			response = {
				success: true,
				code: 200,
				done: false,
				message: "Nope!"
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


# get ALL user info (issues, collaborators, and shared_issues associated with user, by user_id): 
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

			collaborations = []

			found_collaborators1 = Collaboration.where(user_id: params[:id])
			found_collaborators2 = Collaboration.where(collaborator_id: params[:id])

			if found_collaborators1.length > 0 
				found_collaborators1.each do |elem| 
					collaborations.push(elem)
				end
			end

			if found_collaborators2.length > 0 
				found_collaborators2.each do |elem| 
					if not (collaborations.include?(elem)) 
						collaborations.push(elem) 
					end 
				end 
			end  

			shared_issues = [] 

			found_shared_issues1 = Shared_Issue.where(collaborator_id: params[:id])
			found_shared_issues2 = Shared_Issue.where(owner_id: params[:id])

			if found_shared_issues1.length > 0
				found_shared_issues1.each do |elem|
					shared_issues.push(elem)
				end
			end

			if found_shared_issues2.length > 0 
				found_shared_issues2.each do |elem|
					if not (shared_issues.include?(elem))
						shared_issues.push(elem)
					end
				end
			end

			response = {
				success: true,
				code: 200,
				done: true,
				message: "Found user with id #{params[:id]}",
				user: user,
				issues: issues,
				collaborations: collaborations,
				shared_issues: shared_issues 
			}

			response.to_json
		end
	end

	# search users based on a username query 
	post '/search' do 

		if !@payload[:query] or @payload[:query].length < 1

			response = {
				success: true,
				code: 200,
				done: false,
				message: "Invalid search query"
			}

			response.to_json

		else

			exact_match = User.select("username, id").find_by(username: @payload[:query])

			sim_query = "%" + @payload[:query] + "%"
			similar_matches = User.select("username, id").where("username LIKE ?", sim_query)



			response = {
				success: true,
				code: 200,
				done: true,
				message: "Search completed",
				exact_match: exact_match,
				similar_matches: similar_matches
			}

			response.to_json

		end

	end

end