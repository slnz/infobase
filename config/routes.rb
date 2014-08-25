require 'sidekiq/web'
Infobase::Application.routes.draw do
  get "gcx_site_users/new"

  get "gcx_site_users/create"

  resources :gcx_sites
  resources :gcx_site_users

  namespace :api, defaults: {format: 'json'} do
    api_version(module: 'V1', header: {name: 'API-VERSION', value: 'v1'}, parameter: {name: "version", value: 'v1'}, path: {value: 'v1'}) do
      resources :ministries
      resources :regions
      resources :teams do
        collection do
          post :search # This is needed for searches with lots of parameters
        end
      end
      resources :target_areas
      resources :users
      resources :activities
      resources :strategies
      resources :people

      resources :statistics do
        collection do
          get :activity
          get :sp_evangelism_combined
          post :collate_stats
          post :collate_stats_intervals
          post :movement_stages
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
  get 'teams/validate/:name' => 'teams#validate_name'
  get 'locations/validate/:name' => 'locations#validate_name'
  get 'teams/region/:region/state/:state/city/:city' => 'teams#city', :as => :team_city, :constraints => {:city => /.+/}
  get 'teams/region/:region/state/:state/:all' => 'teams#state', :as => :team_state_all
  get 'teams/region/:region/state/:state' => 'teams#state', :as => :team_state
  get 'teams/region/:region/country/:country/city/:city' => 'teams#city', :as => :team_country_city, :constraints => {:city => /.+/}
  get 'teams/region/:region/country/:country/:all' => 'teams#country', :as => :team_country_all
  get 'teams/region/:region/country/:country' => 'teams#country', :as => :team_country
  get 'teams/region/:region/:all' => 'teams#region', :as => :team_region_all
  get 'teams/region/:region' => 'teams#region', :as => :team_region
  get 'teams/ministry/:strategy' => 'teams#ministry', :as => :team_ministry
  post 'teams/:id/add_member/:person_id' => 'teams#add_member', :as => :team_add_member
  delete 'teams/:id/remove_member/:person_id' => 'teams#remove_member', :as => :team_remove_member
  post 'teams/:id/add_leader/:person_id' => 'teams#add_leader', :as => :team_add_leader
  post 'teams/:id/remove_leader/:person_id' => 'teams#remove_leader', :as => :team_remove_leader

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
  get 'locations/region/:region/state/:state/city/:city' => 'locations#city', :as => :location_city, :constraints => {:city => /.+/}
  get 'locations/region/:region/state/:state/:all' => 'locations#state', :as => :location_state_all
  get 'locations/region/:region/state/:state' => 'locations#state', :as => :location_state
  get 'locations/region/:region/country/:country/city/:city' => 'locations#city', :as => :location_country_city, :constraints => {:city => /.+/}
  get 'locations/region/:region/country/:country/:all' => 'locations#country', :as => :location_country_all
  get 'locations/region/:region/country/:country' => 'locations#country', :as => :location_country
  get 'locations/region/:region/:all' => 'locations#region', :as => :location_region_all
  get 'locations/region/:region' => 'locations#region', :as => :location_region
  get 'locations/ministry/:strategy' => 'locations#ministry', :as => :location_ministry
  get 'locations/:location_id/movements/new/:strategy' => 'movements#new', :as => :location_new_strategy
  delete 'locations/:location_id/movements/:id/remove_contact/:person_id' => 'movements#remove_contact', :as => :movement_remove_contact
  post 'locations/:location_id/movements/:id/add_contact/:person_id' => 'movements#add_contact', :as => :movement_add_contact

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
  get 'locations/:location_id/movements/:movement_id/stats' => 'stats#movement', :as => :stats_movement

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
  get 'people/roles/:region' => 'people#roles', :as => :people_roles

  get 'reports' => 'reports#create_report', :as => :create_report
  post 'reports/results' => 'reports#do_report', :as => :do_report
  get 'reports/national' => 'reports#national_report', :as => :national_report
  get 'reports/:region' => 'reports#regional_report', :as => :regional_report
  get 'reports/team/:team_id' => 'reports#team_report', :as => :team_report
  get 'reports/location/:location_id' => 'reports#location_report', :as => :location_report

  get 'movement_reports' => 'movement_reports#create_report', :as => :create_movement_report
  post 'movement_reports/results' => 'movement_reports#do_report', :as => :do_movement_report
  get 'movement_reports/movements' => 'movement_reports#movement_report', :as => :movement_report

  get 'home' => 'home#index'
  post 'home/search' => 'home#search', :as => :advanced_search_results
  get 'home/no' => 'home#no'

  get 'monitors/lb' => 'monitors#lb'

  constraint = lambda { |request| request.session['user_id'] and
    User.find(request.session['user_id']).developer? }

  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  match '/logout' => "application#logout", :as => :logout, via: [:get, :post, :delete]

  root :to => 'home#index'

end
