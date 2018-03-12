class User < ApplicationRecord
	belongs_to :project
	has_and_belongs_to_many :articles
end
