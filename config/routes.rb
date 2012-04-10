Hq::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :tribes, :only => [:index]

  resources :species do
    resources :tribes 
  end
     
  resources :locations do
    post :post_polygon, :on => :collection  
    get :search, :on => :collection
    # post :create_from_point, :on => :collection
  end

  resources :sightings do
    get :download, :on => :collection                  
    get :headlines, :on => :collection
    get :map, :on => :collection
    get :list, :on => :collection
    get :autocomplete_species_common_name, :on => :collection
    get :autocomplete_species_binomial, :on => :collection
    get :autocomplete_tribe_name, :on => :collection
    get :autocomplete_camp_name, :on => :collection
    get :autocomplete_location_name, :on => :collection
    post :filter, :on => :collection
  end

  resources :camps do
    resources :sightings, :only => [:index]
  end

  resources :companies do
    resources :camps
    resources :sightings, :only => [:index]
  end
  
  
  # get "company/:id/camps", :as => :company_camps, :controller => :companies, :action => :camps_index
  # get "sightings/index"
  # 
  # get "sightings/new"
  # 
  # get "sightings/edit"
  get "home/redirect/:model/:id", :controller => 'home', :action => 'redirect'
  get "home/auto_search"
  get "home/tester"
  get "home/index"
  get "home/map"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
