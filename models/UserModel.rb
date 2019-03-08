class User < ActiveRecord::Base
	has_many :errors 
	has_secure_password
end