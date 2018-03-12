class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	http_basic_authenticate_with name: "", password: ENV['PASSWORD']

	def index
		@projects = Project.all		
		@users = User.first(10)
	end

end
