Infobase::Application.routes.draw do
  get "gcx_site_users/new"

  get "gcx_site_users/create"

  resources :gcx_sites
  resources :gcx_site_users

  namespace :api, defaults: {format: 'json'} do 
    namespace :v1 do
      resources :stats do
        collection do
          get :activity
          post :collate_stats
        end
      end
      
      resources :people do
        collection do
          get :is_staff
          post :is_staff
        end
      end
    end
  end
  
  resources :infobase_report_rows
  
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
  match 'teams/validate/:name' => 'teams#validate_name'
  match 'locations/validate/:name' => 'locations#validate_name'
  match 'teams/region/:region/state/:state/city/:city' => 'teams#city', :as => :team_city, :constraints => { :city => /.+/ }
  match 'teams/region/:region/state/:state/:all' => 'teams#state', :as => :team_state_all
  match 'teams/region/:region/state/:state' => 'teams#state', :as => :team_state
  match 'teams/region/:region/country/:country/city/:city' => 'teams#city', :as => :team_country_city, :constraints => { :city => /.+/ }
  match 'teams/region/:region/country/:country/:all' => 'teams#country', :as => :team_country_all
  match 'teams/region/:region/country/:country' => 'teams#country', :as => :team_country
  match 'teams/region/:region/:all' => 'teams#region', :as => :team_region_all
  match 'teams/region/:region' => 'teams#region', :as => :team_region
  match 'teams/ministry/:strategy' => 'teams#ministry', :as => :team_ministry
  match 'teams/:id/add_member/:person_id' => 'teams#add_member', :via => :post, :as => :team_add_member
  match 'teams/:id/remove_member/:person_id' => 'teams#remove_member', :via => :delete, :as => :team_remove_member
  match 'teams/:id/add_leader/:person_id' => 'teams#add_leader', :via => :post, :as => :team_add_leader
  match 'teams/:id/remove_leader/:person_id' => 'teams#remove_leader', :via => :post, :as => :team_remove_leader

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
  match 'locations/region/:region/state/:state/city/:city' => 'locations#city', :as => :location_city, :constraints => { :city => /.+/ }
  match 'locations/region/:region/state/:state/:all' => 'locations#state', :as => :location_state_all
  match 'locations/region/:region/state/:state' => 'locations#state', :as => :location_state
  match 'locations/region/:region/country/:country/city/:city' => 'locations#city', :as => :location_country_city, :constraints => { :city => /.+/ }
  match 'locations/region/:region/country/:country/:all' => 'locations#country', :as => :location_country_all
  match 'locations/region/:region/country/:country' => 'locations#country', :as => :location_country
  match 'locations/region/:region/:all' => 'locations#region', :as => :location_region_all
  match 'locations/region/:region' => 'locations#region', :as => :location_region
  match 'locations/ministry/:strategy' => 'locations#ministry', :as => :location_ministry
  match 'locations/:location_id/movements/new/:strategy' => 'movements#new', :as => :location_new_strategy
  match 'locations/:location_id/movements/:id/remove_contact/:person_id' => 'movements#remove_contact', :via => :delete, :as => :movement_remove_contact
  match 'locations/:location_id/movements/:id/add_contact/:person_id' => 'movements#add_contact', :via => :post, :as => :movement_add_contact

  resources :stats do
    collection do
      get :movement
      get :sp
      get :crs
      get :digital
      put :update
      put :create_digital
      put :confirm_digital
    end
  end
  match 'locations/:location_id/movements/:movement_id/stats' => 'stats#movement', :as => :stats_movement

  resources :people do
    collection do
      get :search
      get :search_results
      post :search_results
      get :roles
      get :merge
      post :confirm_merge
      post :do_merge
      get :search_ids
    end
    member do
      get :merge_preview
      get :involvement
    end
  end
  match 'people/roles/:region' => 'people#roles', :as => :people_roles

  match 'reports' => 'reports#create_report', :as => :create_report
  match 'reports/results' => 'reports#do_report', :via => :post, :as => :do_report
  match 'reports/national' => 'reports#national_report', :as => :national_report
  match 'reports/:region' => 'reports#regional_report', :as => :regional_report
  match 'reports/team/:team_id' => 'reports#team_report', :as => :team_report
  match 'reports/location/:location_id' => 'reports#location_report', :as => :location_report

  match 'movement_reports' => 'movement_reports#create_report', :as => :create_movement_report
  match 'movement_reports/results' => 'movement_reports#do_report', :via => :post, :as => :do_movement_report
  match 'movement_reports/movements' => 'movement_reports#movement_report', :as => :movement_report

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
  # match ':controller(/:action(/:id))(.:format)'
end
