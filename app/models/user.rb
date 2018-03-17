class User < ApplicationRecord
	belongs_to :project
	has_and_belongs_to_many :articles
	enum status: { subscribed: 0, unsubscribed: 1 }
	after_create :temporarily_assign_all_articles

	private
		def temporarily_assign_all_articles
			articles = Article.first(7)
			self.articles = articles
			self.save
		end
end
