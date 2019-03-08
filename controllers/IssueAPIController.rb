class IssueAPIController < ApplicationController 

# /api/v1/issue
	before do
	    if request.post? or request.patch? or request.put?
			payload_body = request.body.read
			@payload = JSON.parse(payload_body).symbolize_keys
			puts "---------> Here's our payload: "
			pp @payload
		end
  end


# create issue: 
  	post '/' do 

  		puts "create issue route hit"

  		issue = Issue.new 
  		issue.name = @payload[:name]
  		issue.description = @payload[:description]
  		issue.owner_id = @payload[:user_id]

  		issue.save 

  		response = {
				success: true,
				code: 201,
				done: true,
				message: "Issue #{issue.name} created",
				new_issue: issue
			}

		  response.to_json 

  	end


# find and return all issues associated with one user: 
  	get '/:id' do 

  		puts "find and return issues route hit"

  		found_issues = Issue.where(owner_id: params[:id])

  		if found_issues.length > 0   

  			response = {
  				success: true, 
  				code: 201,
  				done: true, 
  				message: "Found issues",
  				found_issues: found_issues
  			}
        
        response.to_json
 
  		else 

  			response = {
  				success: true,
  				code: 201, 
  				done: false,
  				message: "No issues found for user with user_id #{params[:id]}",
          found_issues: []
  			}

  			response.to_json

  		end
  	end

# update one issue: 
  	patch '/:id' do 

  		puts "Patch issue route hit"

      found_issue = Issue.find_by id: params[:id]

      if not found_issue 
        
        response = {
          success: true,
          code: 200,
          done: false,
          message: "Found no issue with id #{params[:id]}"
        }

        response.to_json

      else 

        found_issue.name = @payload[:name]
        found_issue.description = @payload[:description]
        
        found_issue.save 
 
        response = {
          success: true,
          code: 201,
          done: true,
          message: "Updated issue with id #{params[:id]}",
          updated_issue: found_issue
        }

         response.to_json 

      end

  	end


# destroy one issue 
  	delete '/:id' do 

  		puts "Delete issue route hit"

      found_issue = Issue.find_by id: params[:id]

      if not found_issue 
        
        response = {
          success: true,
          code: 200,
          done: false,
          message: "Found no issue with id #{params[:id]}"
        }

        response.to_json

      else 

        deleted_issue = found_issue 

        found_issue.destroy  
 
        response = {
          success: true,
          code: 201,
          done: true,
          message: "Deleted issue with id #{params[:id]}",
          deleted: deleted_issue
        }

         response.to_json 

      end

  	end



# NOTES on issue: 
  	# post '/note/:id' do 

  	# end


  	# delete '/note/:id' do 

  	# end


  	# patch '/note/:id' do 

  	# end



# TAGS on issue: 
  	# post '/tag/:id' do 


  	# end


  	# delete '/tag/:id' do 


  	# end

end