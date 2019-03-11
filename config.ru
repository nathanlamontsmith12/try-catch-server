require 'sinatra/base'


# require controllers 
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/UserAPIController'
require './controllers/IssueAPIController'
require './controllers/ProfileAPIController'
require './controllers/CollabAPIController'


# models
require './models/UserModel'
require './models/IssueModel'
require './models/NoteModel'
require './models/TagModel'
require './models/CollaboratorModel'


# specify routes 
map '/' do
    run ApplicationController
end

map '/user' do 
    run UserController 
end

map '/api/v1/user' do 
	run UserAPIController 
end

map '/api/v1/issue' do 
	run IssueAPIController 
end

map '/api/v1/profile' do 
	run ProfileAPIController
end

map '/api/v1/collab' do 
	run CollabAPIController 
end 
