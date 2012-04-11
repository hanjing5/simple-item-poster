Adserver::Application.routes.draw do
 
  # Pages  
  match "/index", :to => "pages#index"
  match "/misc", :to => "pages#misc"
  match "/about", :to => "pages#about"
  match "/contact", :to => "pages#contact"
  match "/docs", :to => "pages#documentation"
  match "/admin/products", :to => "pages#products", :as => :admin_products
  match "/admin/users", :to => "pages#users", :as => :admin_users

  devise_for :companies, :controllers => {:registrations => "registrations", :passwords=>"passwords", :sessions=>"sessions"} do
    get 'companies', :to => "companies#show", :as => :company_root
  end
	resources :passwords

	match "g/:encrypted_link" => "products#single_shop", :as => :single_shop

	resources :companies, :only => [:new, :show, :index, :create, :edit,:update] do
		get 'account', :on=>:collection
		get 'edit_password', :on=>:collection
		get 'bank', :on=>:collection
		post 'update_password', :on=>:collection
		resources :products do
			get 'first_product', :on=>:collection
		end
  		resources :coupons  # name space to change url 
	  	resources :ads do
			post 'api_login', :on => :collection
		end
	end

  devise_for :publishers, :controllers => {:registrations => "registrations"} do
    get 'publishers', :to => "publishers#show",:as => :publisher_root
  end
  resources :payments

  # Matches new_token url for platforms/publishers to create tokens for API calls
  # This route can be invoked with new_token_url(:id => current_publisher.id)
  match 'publishers/:id/new_token' => 'publishers#new_token', :as => :new_token

  resources :publishers, :only => [:new, :show, :index, :new_token] do
    resources :games
  end

  # Matches new_token url for games to create tokens for API calls
  # This route can be invoked with 
  # new_game_token_url(:publisher_id => current_publisher.id, :game_id => game.id)
  match 'publishers/:publisher_id/games/:game_id/new_token' => 'games#new_token', :as => :new_game_token
  # resources :ads, :only => [:index]
  resources :ads, :only => [:api_login] do
      post 'api_login', :on => :collection
  end

  devise_for :users, :controllers => {:registrations => "registrations", :sessions=>"sessions"} do
	get 'users', :to => "products#inventory_display", :as => :user_root
	get 'users/sign_out'=>'devise/sessions#destroy'
  end

  resources :users, :only => [:new, :show, :index] do
  	resources :payments
		resources :shipping_addresses
    post 'api_login', :on => :collection
  end

  ######## region API use #########
  # Separated environment used for Pacman's TESTING
  # fixed the style problem that was causing cancer
  # go to home.com/api/coupon.xml to see result

  match "/api/v1/coupon_form", :to => "tmp_users#show" #display submit form 
  match "/api/v1/coupon_form/create", :to => "tmp_users#create" 
  match "/api/v1/coupon_form/success", :to => "tmp_users#success" 
  match "/api/v1/coupon_form/failure", :to => "tmp_users#failure" 
  match "/api/v1/coupon_form/redeemed_to_soon", :to => "tmp_users#redeemed_to_soon" 

  # RESTful API for coupons
  match "/api/v1/coupon", :to => "coupons#random_api"
  match "/api/v1/coupon", :to => "coupons#update_coupon_api", :via=>:put #only put method
  # given a game token and an email, redeem the coupon
  match "/api/v1/coupon/redeem", :to => "tmp_users#create" 

  match "/api/v1/product", :to => "products#update_product_api", :via=>:put #only put method
  match "/api/v1/product", :to => "products#random_api"

  match "/api/v1/product/confirm_purchase", :to => "products#confirm_purchase"
  match "/api/v1/product/purchase/create", :to => "products#confirm_purchase_create", :as=>:purchase_create
  match "/api/v1/product/purchase/success", :to => "products#purchase_success"

  match "/g/:encrypted_link/create", :to => "products#confirm_purchase_single_shop_create", :as=>'confirm_purchase_single_shop_create'
  match "/g/:encrypted_link/card", :to => "products#single_shop_with_credit_card", :as=>'confirm_purchase_single_shop_with_credit_card'
  #match "/g/:encrypted_link/success", :to => "products#purchase_single_success"
  match "/g/:encrypted_link/:id/:success", :to => "products#purchase_single_success"
  match "/g/:encrypted_link/:id/:success/download", :to => "products#download"

  match "/api/v1/product/user_prompt" => 'users#product_user_prompt', :as => :product_user_prompt

  match "/api/v1/product/user_sign_in" => 'users#product_user_sign_in', :as => :product_user_sign_in
  match "/api/v1/product/user_register" => 'users#product_user_register', :as => :product_user_register

  match "/api/v1/product/shipping_address" => 'shipping_addresses#new', :as => :new_shipping_address
  match "/api/v1/product/shipping_address/create" => 'shipping_addresses#create', :as => :create_shipping_address

  match "/api/v1/product/user_credit_card" => 'users#credit_card_new', :as => :new_credit_card
  match "/api/v1/product/user_credit_card/create" => 'users#credit_card_create', :as => :create_credit_card

  match "/api/v1/user", :to => "tmp_users#create", :via=>:post #post email, coupon_id, token

  match "/api/v1/product_inventory_display", :to => "products#inventory_display" #display submit form 

  match "/api/coupon/show", :to => "coupons#show"
  resources :coupons

  # REST API Product Stuff
  match "/api/v1/users", :to => "users#api_login"
  match "/api/v1/users/create", :to => "users#api_user_create"

  match "/api/v1/shipping_address" => 'shipping_addresses#api_shipping_address_token'
  match "/api/v1/shipping_address/create" => 'shipping_addresses#api_shipping_address_create', :via=>:post

  match "/api/v1/user/credit_card" => 'users#api_credit_card_token'
  match "/api/v1/user/credit_card/create" => 'users#api_credit_card_create', :via=>:post

  match "/api/v1/shop/last_buy" => 'products#api_invoice_token'
  match "/api/v1/shop/buy" => 'products#api_purchase_create', :via=>:post


  #################################

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
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
