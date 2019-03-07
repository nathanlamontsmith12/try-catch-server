require 'sinatra/base'

# require controllers 
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/UserAPIController'

# models
require './models/UserModel'


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