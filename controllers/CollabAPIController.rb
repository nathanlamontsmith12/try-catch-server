class CollabAPIController < ApplicationController 

# /api/v1/collab
	before do
	    if request.post? or request.patch?
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload
		end
  end


  	# add collaborator  
  	post '/' do

  		# check that the ids refer to actual users 
  		found_user1 = User.find_by id: @payload[:user_id]
  		found_user2 = User.find_by id: @payload[:collaborator_id]


  		# check in case they are already collaborators 
      already_collab = false 
  		
      to_check = Collaboration.where("user_id = ? OR collaborator_id = ?", @payload[:user_id], @payload[:user_id])
  		
      puts "collabs to check (total): "
      pp to_check 

      to_check.each do |collab| 
        if (collab.user_id == @payload[:collaborator_id]) or (collab.collaborator_id == @payload[:collaborator_id]) 
          already_collab = true
        end
      end

  		if !found_user1 or !found_user2

  			response = {
  				success: true,
  				code: 200,
  				done: false,
  				message: "At least one of the two user ids does not have associated user in database"
  			}

  			response.to_json 

  		elsif already_collab

  			response = {
  				success: true,
  				code: 200,
  				done: false,
  				message: "These two users are already associated through a collaboration!"
  			}

  			response.to_json 

  		else 

        # make a new collaboration: 
  			collaboration = Collaboration.new 

  			collaboration.user_id = @payload[:user_id]
        collaboration.initiator = found_user1.username 
  			collaboration.collaborator_id = @payload[:collaborator_id]
        collaboration.collaborator = found_user2.username 

  			collaboration.save 

    		response = {
    			success: true,
    			code: 201,
    			done: true,
    			message: "Created a collaboration association between the two users",
    			collaboration: collaboration
    		}

	  		response.to_json

	  	end 

  	end


    # update collaboration from pending "true" to pending "false" (active)    
    patch '/:collaboration_id' do 

      # check that collaboration exists, and that user id is "collaborator_id" 
      collaboration_to_update = Collaboration.find_by id: params[:collaboration_id]

      if not collaboration_to_update 

        response = {
          success: true,
          code: 200,
          done: false,
          message: "Failed to find the collaboration"
        }

        response.to_json

      elsif collaboration_to_update.collaborator_id != @payload[:user_id]

        response = {
          success: true,
          code: 200,
          done: false,
          message: "Current user is not authorized to activate the collaboration"
        }

        response.to_json 

      else 

        # after checking all is kosher, activate collaboration: 
        collaboration_to_update.pending = false

        collaboration_to_update.save 

        response = {
          success: true,
          code: 200,
          done: true,
          message: "Activated collaboration",
          collaboration: collaboration_to_update
        }

        response.to_json 

      end

    end


  	# share issue with a collaborator 
  	post '/share' do 

      # check that everything is kosher: 
      owner = User.find_by id: @payload[:owner_id]
      collaborator = User.find_by id: @payload[:collaborator_id]
      collaboration = Collaboration.find_by id: @payload[:collaboration_id]
      issue = Issue.find_by id: @payload[:issue_id]
      
      extant_shared_issue = Shared_Issue.find_by issue_id: @payload[:issue_id]

      if extant_shared_issue and (extant_shared_issue.collaborator_id == @payload[:collaborator_id])

        response = {
          success: true,
          code: 200,
          done: false,
          message: "This issue has already been shared with #{collaborator.username}"
        }

        response.to_json 

      elsif owner and collaborator and collaboration and issue

        if collaboration.pending 

          response = {
            success: true,
            code: 200,
            done: false,
            message: "Collaboration exists, but is pending (not activated)"
          }

          response.to_json

        else  

          shared_issue = Shared_Issue.new

          shared_issue.collaboration_id = @payload[:collaboration_id]
          shared_issue.issue_id = @payload[:issue_id]

          shared_issue.owner_id = @payload[:owner_id]
          shared_issue.owner_name = owner.username 
          
          shared_issue.collaborator_id = @payload[:collaborator_id]
          shared_issue.collaborator_name = collaborator.username 

          shared_issue.name = issue.name 
          shared_issue.description = issue.description 

          shared_issue.save 
          
          response = {
            success: true,
            code: 201,
            done: true,
            message: "Created a new shared issue association",
            shared_issue: shared_issue 
          }

          response.to_json 

        end

      else 

        message = "Failed to create new shared issue association"

        response = {
          success: true,
          code: 200,
          done: false,
          message: "Failed to create new shared issue association"
        }

        response.to_json 

      end 

  	end


  	# remove collaborator AND unshare all files between the two  
  	delete '/:collaboration_id' do 

      collaboration_to_delete = Collaboration.find_by id: params[:collaboration_id]

      if not collaboration_to_delete

        response = {
          success: true,
          code: 200,
          done: false,
          message: "Failed to delete the collaboration association"
        }

        response.to_json

      else 

        deleted_item = collaboration_to_delete

        collaboration_to_delete.destroy 

        response = {
          success: true,
          code: 200,
          done: true,
          message: "Destroyed the collaboration association",
          deleted_collaboration: deleted_item
        }

        response.to_json

      end

  	end


  	# unshare issue with user 
    # NOTE: the "id" in the params below
  	delete '/shared_issue/:shared_issue_id' do 

      shared_issue_to_delete = Shared_Issue.find_by id: params[:shared_issue_id]

      if not shared_issue_to_delete

        response = {
          success: true,
          code: 200,
          done: false,
          message: "Failed to delete the collaboration association"
        }

        response.to_json        

      else

        deleted_item = shared_issue_to_delete

        shared_issue_to_delete.destroy 

        response = {
          success: true,
          code: 200,
          done: true,
          message: "Deleted shared_issue association",
          deleted_shared_issue: deleted_item
        }

        response.to_json

      end

  	end

end