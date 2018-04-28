Rails.application.routes.draw do
	get '/articles_for_user/:user_token.json', to: 'articles#for_user'
	resources :articles

	# namespace "0.1" do
		post '/users/update_timezone.json', to: 'users#update_timezone'
		post '/users/unsubscribe.json', to: 'users#unsubscribe'
		post '/users/status.json', to: 'users#status'
		get '/users/per_day.json', to: 'users#per_day'
		resources :users
	# end
	resources :projects
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root 'application#index'
end
