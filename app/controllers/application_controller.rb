class ApplicationController < ActionController::Base
	# protect_from_forgery with: :exception
	http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']

	def index
		@projects = Project.all
		@projects_count = Project.count		
		@users = User.first(10)
		@users_count = User.count
		@unsubscribed_count = User.unsubscribed.count
		@articles = Article.first(10)
		@articles_count = Article.count
	end

end
