class Article < ApplicationRecord
	serialize :content, JSON
	belongs_to :project
	has_and_belongs_to_many :users
	before_save :sanitize_json

	private
		def sanitize_json
			self.content = JSON.parse(self.content)
		end
end
