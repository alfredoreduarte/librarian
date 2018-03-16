class Article < ApplicationRecord
	serialize :content, JSON
	belongs_to :project
	has_and_belongs_to_many :users
end
