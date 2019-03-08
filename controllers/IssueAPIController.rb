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


# ============== Issues on User: ==============
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




# ============== NOTES on issue: ==============

    # find all notes associated with one issue: 

    get '/note/:id' do 

      puts "get all notes on error w/ id #{params[:id]}"

      found_notes = Notes.where(issue_id: params[:id])
      
      if found_notes.length > 0   

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "Found notes",
          found_notes: found_notes
        }
        
        response.to_json
 
      else 

        response = {
          success: true,
          code: 201, 
          done: false,
          message: "No notes found for issue with issue_id #{params[:id]}",
          found_notes: []
        }

        response.to_json

      end
    end


# post a note to an issue 
  	post '/note/:id' do 

      puts "add note to issue with id #{params[:id]}"

      target_issue = Issue.find_by id: params[:id]

      if not target_issue 

        response = {
          success: true, 
          code: 201,
          done: false, 
          message: "No issue found with id #{params[:id]}"
        }

        response.to_json 

      else 

        new_note = Note.new 
        new_note.name = @payload[:name]
        new_note.content = @payload[:content]
        new_note.issue_id = @payload[:issue_id]

        new_note.save 

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "created new note on issue with id #{params[:id]}",
          new_note: new_note 
        }

        response.to_json 

      end

  	end


# delete a note from an issue 
  	delete '/note/:id' do 

      puts "delete note with id #{params[:id]}"

      target_note = Note.find_by id: params[:id]

      if not target_note 

        response = {
          success: true, 
          code: 201,
          done: false, 
          message: "No note found with id #{params[:id]}"
        }

        response.to_json 

      else 

        deleted_note = target_note

        target_note.destroy 

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "deleted note with id #{params[:id]}",
          deleted_note: deleted_note 
        }

        response.to_json 

      end      

  	end


# update a note on an issue 
  	patch '/note/:id' do 

      puts "update note with id #{params[:id]}"

      target_note = Note.find_by id: params[:id]

      if not target_note 

        response = {
          success: true, 
          code: 201,
          done: false, 
          message: "No note found with id #{params[:id]}"
        }

        response.to_json 

      else 

        target_note.name = @payload[:name]
        target_note.content = @payload[:content]

        target_note.save 

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "updated note with id #{params[:id]}",
          new_note: target_note 
        }

        response.to_json 

      end    

  	end




# ============== TAGS on issue: ==============

    # find all tags associated with one issue: 
    get '/tag/:id' do 

      found_tags = Tags.where(issue_id: params[:id])
      
      if found_tags.length > 0   

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "Found tags",
          found_tags: found_tags
        }
        
        response.to_json
 
      else 

        response = {
          success: true,
          code: 201, 
          done: false,
          message: "No tags found for issue with issue_id #{params[:id]}",
          found_tags: []
        }

        response.to_json

      end

    end


    # create new tag on issue w/ id == params[:id]
  	post '/tag/:id' do 

      target_issue = Issue.find_by id: params[:id]

      if not target_issue 

        response = {
          success: true, 
          code: 201,
          done: false, 
          message: "No issue found with id #{params[:id]}"
        }

        response.to_json 

      else 

        new_tag = Tag.new 
        new_tag.content = @payload[:content]
        new_tag.issue_id = @payload[:issue_id]

        new_tag.save 

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "created new tag on issue with issue_id #{params[:id]}",
          new_tag: new_tag 
        }

        response.to_json 

      end

  	end


    # delete tag with id params[:id]
  	delete '/tag/:id' do 

      target_tag = Tag.find_by id: params[:id]

      if not target_tag 

        response = {
          success: true, 
          code: 201,
          done: false, 
          message: "No tag found with id #{params[:id]}"
        }

        response.to_json 

      else 

        deleted_tag = target_tag

        target_tag.destroy 

        response = {
          success: true, 
          code: 201,
          done: true, 
          message: "deleted tag with id #{params[:id]}",
          deleted_tag: deleted_tag
        }

        response.to_json 

      end   

  	end

end