require 'sinatra/base'


# require controllers 
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/UserAPIController'
require './controllers/IssueAPIController'


# models
require './models/UserModel'
require './models/IssueModel'
require './models/NoteModel'
require './models/TagModel'


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
