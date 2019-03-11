class CollabAPIController < ApplicationController 

# /api/v1/collab
	before do
	    if request.post? or request.patch? or request.put?
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload
		end
  	end

  	# add collaborator to user 

end