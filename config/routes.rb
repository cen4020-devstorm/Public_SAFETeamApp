
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
#   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
#   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

# Rails.application.routes.draw do
#   resources :user_infos, only: [:new, :create, :show]
#   root "user_infos#new"
# end

Rails.application.routes.draw do
  # Root: go to home page
  root "pages#index"

  #Path to redirect controller and outside_hours page
  get "ride_redirect", to: "pages#ride_redirect"
  get 'outside_hours', to: 'pages#outside_hours' 

  # User registration
  get  "/signup", to: "users#new"
  post "/signup", to: "users#create"

  # User login/logout
  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  #Admin Routes
  get 'admin_dashboard', to: 'admin#dashboard'

  resources :ride_requests
  
  Rails.application.routes.draw do
    # Define a route for selecting a building and getting the address
    get '/select_building_address', to: 'buildings#select_building_address'
  end

  resources :ride_requests do
    member do
      post :notify_on_the_way
      post :notify_arrived
      post :complete
    end
  end
  # Ride request system
  # This creates routes for user_infos#new, user_infos#create, and user_infos#show and user_infos#index
  resources :ride_requests, only: [:new, :create, :show, :index, :destroy]
  resources :travel_times, only: [:new, :create, :show]
end


