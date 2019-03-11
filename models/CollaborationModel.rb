class Collaboration < ActiveRecord::Base
	belongs_to :user
	has_many :shared_issues
end