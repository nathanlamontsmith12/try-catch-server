class User < ActiveRecord::Base
	has_many :issues 
	has_many :collaborations
	has_secure_password
end