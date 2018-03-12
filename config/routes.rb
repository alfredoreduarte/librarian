Rails.application.routes.draw do
	resources :articles

	# namespace "0.1" do
		post '/users/update_timezone.json', to: 'users#update_timezone'
		post '/users/status.json', to: 'users#status'
		get '/users/:id/articles.json', to: 'users#articles'
		resources :users
	# end
	resources :projects
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root 'application#index'
end
