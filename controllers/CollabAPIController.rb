class CollabAPIController < ApplicationController 

# /api/v1/collab
	before do
	    if request.post? 
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload
		end
  	end

# CREATE TABLE collaborators(
# 	id SERIAL PRIMARY KEY,
# 	user_id INTEGER REFERENCES users(id) ON DELETE CASCADE, 
# 	collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE 
# );


# CREATE TABLE shared_issues(
# 	id SERIAL PRIMARY KEY,
# 	owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
# 	issue_id INTEGER REFERENCES issues(id) ON DELETE CASCADE,
# 	collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
# 	association_id INTEGER REFERENCES collaboration(id) ON DELETE CASCADE
# );


  	# add collaborator  
  	post '/' do

  		# check that the ids refer to actual users 
  		found_user1 = User.find_by id: @payload[:user_id]
  		found_user2 = User.find_by id: @payload[:collaborator_id]

  		# check in case they are already collaborators 
  		found_collab1 = Collaboration.find_by user_id: @payload[:user_id]
  		found_collab2 = Collaboration.find_by collaborator_id @payload[:collaborator_id]

  		if !found_user1 or !found_user2

  			response = {
  				success: true,
  				code: 200,
  				done: false,
  				message: "At least one of the two user ids does not have associated user in database"
  			}

  			response.to_json 

  		elsif found_collab1 or found_collab2 

  			response = {
  				success: true,
  				code: 200,
  				done: false,
  				message: "These two users already have collaborator association"
  			}

  			response.to_json 

  		else 

  			collaboration = Collaboration.new 

  			collaboration.user_id = @payload[:user_id]
  			collaboration.collaborator_id = @payload[:collaborator_id]

  			collaboration.save 

			response = {
				success: true,
				code: 201,
				done: true,
				message: "Created a collaborator association between the users",
				collaboration: collaboration 
			}

	  		response.to_json
	  	end 
  	end


  	# share issue with a collaborator 
  	post '/share' do 

  	end


  	# remove collaborator AND unshare all files between the two 
  	post '/remove' do 

  	end


  	# unshare issue with user 
  	post '/unshare' do 

  	end

end