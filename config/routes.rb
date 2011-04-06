Medibooking::Application.routes.draw do
  
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
  # root :to => "welcome#index"
  
  # See how all your routes lay out with "rake routes"
  
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  root :to => "application#index"
  
  
  match "user/activate/:activation_key" => "users#activate", :via=>[:get], :as=>:activate_user
  match "user/reset_password" =>"users#reset_password", :via=>[:get, :post], :as=>:reset_password
  match "user/create_new_password/:reset_password_key" =>"users#create_new_password",:via=>[:get, :put], :as=>:create_new_password
  match "user/profile" =>"users#profile", :via=>[:get], :as=>:user_profile
  match "user/profile/change_password" =>"users#change_password", :via=>[:get, :put], :as=>:user_change_password
  match "user/profile/preferences" =>"users#profile", :via=>[:get], :as=>:user_preferences
  
  
  match "staffer/dashboard/:id" =>"staffers#dashboard", :via=>[:get], :as=>:staffer_dashboard
  
  resources :users
  resources :staffers, :controller=>"users" 
  
  
  
  
  
  match "/business_admins/new(.:format)" => "business_admins#new", :via=>[:get], :as=>:new_business_admin
  match "/business_admins(.:format)" => "business_admins#create", :via=>[:post], :as=>:business_admins
  
  
  

  match "/business_accounts/:business_account_id/staffers/:id/send_activation_email(.:format)" => "business_accounts/staffers#send_activation_email", :via=>[:put], :as=>:send_staffer_activation_email
  match "/business_accounts/:business_account_id/admins/:id/send_activation_email(.:format)" => "business_accounts/admins#send_activation_email", :via=>[:put], :as=>:send_admin_activation_email
   
  
  resources :business_admins, :controller=>"users", :except=>[:new, :create] do
    #resources :staffers, :controller=>"users", :except=>[:new, :create, :index, :show, :edit, :update, :destroy]
    #resources :staffers, :controller=>"business_admins/staffers"
    #resources :businesses
  end
  
  resources :business_accounts do
    resources :businesses, :except=>[:index]
    resources :staffers, :controller=>"business_accounts/staffers"
    resources :admins, :controller=>"business_accounts/admins"
  end
  match "/business_accounts/:business_account_id/availability" => "business_accounts#availability", :via=>[:get, :put], :as=>:business_account_availability
  match "/business_accounts/:business_account_id/availability_exceptions" => "business_accounts#availability_exceptions", :via=>[:put], :as=>:business_account_availability_exceptions
  
  match "/business_accounts/:business_account_id/specialities" => "business_accounts#specialities", :via=>[:get], :as=>:business_account_specialities
  
  
  
  resources :sessions, :only=>[:new, :create]
  #resources :businesses
  #match "business/:short_name/dashboard" => "businesses#show", :via=>[:get], :as=>:manage_business
  match "business/:business_account_id/dashboard" =>"business_accounts#index", :via=>[:get], :as=>:business_dashboard
  match "session/delete" =>"sessions#destroy", :via=>[:delete], :as=>:delete_session
  
  
end
