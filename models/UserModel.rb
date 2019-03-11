class User < ActiveRecord::Base
	has_many :issues 
	has_many :collaborators
	has_many :shared_issues 
	has_secure_password
end