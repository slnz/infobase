Infobase::Application.routes.draw do
  resources :teams do
    collection do
      get :search
      get :search_results
      post :search_results
      get :region
      get :state
      get :ministry
    end
    member do
      post :add_member
      delete :remove_member
      get :search_members
      post :search_members_results
      get :new_member
      post :create_member
      post :add_leader
      post :remove_leader
    end
  end
  match 'teams/region/:region/state/:state/city/:city' => 'teams#city'
  match 'teams/region/:region/state/:state/:all' => 'teams#state'
  match 'teams/region/:region/state/:state' => 'teams#state'
  match 'teams/region/:region/country/:country/city/:city' => 'teams#city'
  match 'teams/region/:region/country/:country/:all' => 'teams#country'
  match 'teams/region/:region/country/:country' => 'teams#country'
  match 'teams/region/:region/:all' => 'teams#region'
  match 'teams/region/:region' => 'teams#region'
  match 'teams/ministry/:strategy' => 'teams#ministry'
  match 'teams/:id/add_member/:person_id' => 'teams#add_member', :via => :post
  match 'teams/:id/remove_member/:person_id' => 'teams#remove_member', :via => :delete
  match 'teams/:id/add_leader/:person_id' => 'teams#add_leader', :via => :post
  match 'teams/:id/remove_leader/:person_id' => 'teams#remove_leader', :via => :post

  resources :locations do
    resources :movements do
      member do
        post :add_contact
        delete :remove_contact
        get :search_contacts
        post :search_contacts_results
        get :new_contact
        post :create_contact
        delete :unbookmark
      end
    end
    collection do
      get :search
      get :search_results
      post :search_results
      get :region
      get :state
      get :ministry
    end
  end
  match 'locations/region/:region/state/:state/city/:city' => 'locations#city'
  match 'locations/region/:region/state/:state/:all' => 'locations#state'
  match 'locations/region/:region/state/:state' => 'locations#state'
  match 'locations/region/:region/country/:country/city/:city' => 'locations#city'
  match 'locations/region/:region/country/:country/:all' => 'locations#country'
  match 'locations/region/:region/country/:country' => 'locations#country'
  match 'locations/region/:region/:all' => 'locations#region'
  match 'locations/region/:region' => 'locations#region'
  match 'locations/ministry/:strategy' => 'locations#ministry'
  match 'locations/:location_id/movements/new/:strategy' => 'movements#new'
  match 'locations/:location_id/movements/:id/remove_contact/:person_id' => 'movements#remove_contact', :via => :delete
  match 'locations/:location_id/movements/:id/add_contact/:person_id' => 'movements#add_contact', :via => :post
  
  resources :stats do
    collection do
      get :movement
      put :update
    end
  end
  match 'locations/:location_id/movements/:movement_id/stats' => 'stats#movement'

  resources :people do
    collection do
      get :search
      get :search_results
      post :search_results
      get :roles
    end
  end
  match 'people/roles/:region' => 'people#roles'
  
  match 'reports' => 'reports#create_report', :as => :create_report
  match 'reports/results' => 'reports#do_report', :via => :post, :as => :do_report
  match 'reports/national' => 'reports#national_report', :as => :national_report
  match 'reports/:region' => 'reports#regional_report', :as => :regional_report
  match 'reports/team/:team_id' => 'reports#team_report', :as => :team_report
  
  match 'home' => 'home#index'
  match 'home/search' => 'home#search', :via => :post, :as => :advanced_search_results
  match 'home/no' => 'home#no'
  
  root :to => 'home#index'

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
