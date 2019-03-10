# HEADS UP! i18n 1.1 changed fallbacks to exclude default locale.
# But that may break your application.

# Please check your Rails app for 'config.i18n.fallbacks = true'.
# If you're using I18n (>= 1.1.0) and Rails (< 5.2.2), this should be
# 'config.i18n.fallbacks = [I18n.default_locale]'.
# If not, fallbacks will be broken in your app by I18n 1.1.x.

# For more info see:
# https://github.com/svenfuchs/i18n/releases/tag/v1.1.0


class ApplicationController < Sinatra::Base
	require 'bundler'
	Bundler.require()

	Dotenv.load

	# envoronment config
	require './config/environments'

	# enable :sessions
	secret = ENV['SESSION_SECRET']

	use Rack::Session::Cookie, :key => 'rack.session',
                               :path => '/',
    						   :secret => secret

    # Set up CORS
	register Sinatra::CrossOrigin

	configure do
		enable :cross_origin
	end

	set :allow_origin, :any
	set :allow_methods, [:get, :post, :put, :options, :patch, :delete, :head]
	set :allow_credentials, true                        
    
    # middleware here
    use Rack::MethodOverride
  	set :method_override, true

	# firnd templates
	set :views, File.expand_path('../../views', __FILE__)

	# find static assets
	set :public_dir, File.expand_path('../../public', __FILE__)

	#browser options
	options "*" do 
		response.headers["Allow"] = "HEAD,GET,PUT,PATCH,POST,DELETE,OPTIONS" 
		response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
		200
	end

	get '/' do 
		@session = session 
		erb :home
	end

	get '/test' do	
		"reached test route"

		if ENV['RACK_ENV'] == "development"
			binding.pry
		end

		redirect '/'
	end

	get '*' do
		halt 404
	end
end