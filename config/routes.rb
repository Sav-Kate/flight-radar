Rails.application.routes.draw do
  get '/flight_route/:flight_number', to: 'flight_radar#flight_route'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
