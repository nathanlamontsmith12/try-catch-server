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

  		response = {  			
				success: true,
				code: 200,
				done: true,
				message: "TEST: Update user profile; nothing done"
			}

		response.to_json 

  	end

end


# bio: "Hey I am just a random and crazy guy!"
# email: "ffff@ffff.com"
# id: 4
# newPassword: "ffff"
# password: "asdf"
# user_id: 4
# username: "guy"