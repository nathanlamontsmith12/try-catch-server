class User < ActiveRecord::Base
	has_many :issues 
	has_secure_password
end