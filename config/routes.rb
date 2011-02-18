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
  
  resources :users
  
  match "/business_admins/new(.:format)" => "business_admins#new", :via=>[:get], :as=>:new_business_admin
  match "/business_admins(.:format)" => "business_admins#create", :via=>[:post], :as=>:business_admins
  
  
  
  match "/business_admins/:business_admin_id/staffers(.:format)" => "staffers#index", :via=>[:get], :as=>:business_admin_staffers
  match "/business_admins/:business_admin_id/staffers(.:format)" => "staffers#create", :via=>[:post], :as=>:business_admin_staffers
  match "/business_admins/:business_admin_id/staffers/new(.:format)" => "staffers#new", :via=>[:get], :as=>:new_business_admin_staffer
  match "/business_admins/:business_admin_id/staffers/:id(.:format)" => "staffers#show", :via=>[:get], :as=>:business_admin_staffer
  match "/business_admins/:business_admin_id/staffers/:id/edit(.:format)" => "staffers#edit", :via=>[:get], :as=>:edit_business_admin_staffer
  match "/business_admins/:business_admin_id/staffers/:id(.:format)" => "staffers#update", :via=>[:put]
  
  
  
  resources :business_admins, :controller=>"users", :except=>[:new, :create] do
    resources :staffers, :controller=>"users", :except=>[:new, :create, :index, :show, :edit]
    resources :businesses
  end
  
  
  resources :sessions, :only=>[:new, :create]
  #resources :businesses
  #match "business/:short_name/dashboard" => "businesses#show", :via=>[:get], :as=>:manage_business
  match "business/dashboard" =>"businesses#index", :via=>[:get], :as=>:business_dashboard
  match "session/delete" =>"sessions#destroy", :via=>[:delete], :as=>:delete_session
  
  
end
