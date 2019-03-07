require 'sinatra/base'

# require controllers 
require './controllers/ApplicationController'

# models


# specify routes 
map '/' do
  run ApplicationController
end