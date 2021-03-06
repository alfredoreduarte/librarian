class Article < ApplicationRecord
	serialize :content, JSON
	belongs_to :project
	has_many :readings
	has_many :users, through: :readings
	# before_save :sanitize_json

	def self.simulate_dates
		today = DateTime.now
		Article.order(id: :asc).all.each do |art|
			art.created_at = today
			art.updated_at = today
			today = today - 1.day
			art.save
		end
	end

	private
		# def sanitize_json
			# self.content = JSON.parse(self.content)
			# self.content = self.content.to_s
		# end
end
