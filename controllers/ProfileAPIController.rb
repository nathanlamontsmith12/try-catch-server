class ProfileAPIController < ApplicationController 

# /api/v1/profile
	before do
	    if request.post? or request.patch? or request.put?
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload
		end
  	end

  	patch '/:id' do 

  		puts "Update User Profile Route Hit"

  		# update profile 
  		current_user = User.find_by id: @payload[:user_id]

  		pw = @payload[:password]
  		new_pw = @payload[:newPassword]

		if current_user and pw and current_user.authenticate(pw)

			current_user.email = @payload[:email]
			current_user.bio = @payload[:bio]

			if @payload[:newPassword] 
				current_user.password = new_pw 
			end 

			current_user.save 

			response = {
				success: true,
				code: 200,
				done: true,
				message: "Updated user account."
			}

			response.to_json

		else 

			response = {
				success: true,
				code: 200,
				done: false,
				message: "User does not exist, or password incorrect. No profile updated."
			}

			response.to_json 

		end

	end


end
