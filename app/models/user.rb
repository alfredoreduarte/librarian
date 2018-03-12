class User < ApplicationRecord
	belongs_to :project
	has_and_belongs_to_many :articles
	enum status: { subscribed: 0, unsubscribed: 1 }
end
