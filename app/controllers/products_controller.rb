class ProductsController < ApplicationController

	# use this or add protect_from_forger :except=> :create
	skip_before_filter :verify_authenticity_token, :except => [:create, :destroy, :update]
	
	###########################################################
	# single_shop is the controller for the single OUT OF ENVIRONMENT
	# purchase page
	# The main difference between this and confirm_purchase
	# methods is that this one doesn't care if there is no user
	# or shipping address
	###########################################################
	def single_shop
		# unencypt the id
		@product_id = params[:encrypted_link].to_i(32)
		@product = Product.find(@product_id)
		@product['picture_path'] = ''
		if @product.picture_file_name
			@product['picture_path'] = picture_path_builder(root_url, @product) + @product.picture_file_name
		end
		render :layout => false	
	end

	###########################################################
	# Just in case user does not have javascript enabled
	###########################################################
	def single_shop_with_credit_card
		respond_to do |format|
			format.js do
				@product = Product.find(params[:product_id].to_i(32))
				return
			end
			format.html do
				@product_id = params[:encrypted_link].to_i(32)
				@product = Product.find(@product_id)
				@product['picture_path'] = ''
				if @product.picture_file_name
					@product['picture_path'] = picture_path_builder(root_url, @product) + @product.picture_file_name
				end
				render :layout => false	
				return
			end
		end
	end

	###########################################################
	# store invoices, send Strip the command to buy the item
	# update earnings for the seller
	###########################################################
	def confirm_purchase_single_shop_create
		# check for payment info
		# send to stripe for a credit card token
		Stripe.api_key = "9sir8teed4nvvwDoSOjBgy29k4pNy3iF"
		# get credit card info
		# send to stripe and/or store it through post call
		begin
			response = Stripe::Token.create(:card=>params[:card],:currency=>"usd")
		rescue StandardError => err
			# catch the errors that stripe throws
			flash[:error] = 'Credit card info errors. Please check your entry again.'
			puts err
			redirect_to :action=>'single_shop_with_credit_card', :layout=>false, :encrypted_link=>params[:encrypted_link]
			return
		end

		# find the product
		@product = Product.find(params[:encrypted_link].to_i(32))

		# catch token and store that
		@token = response.zip[7][0][1]
		puts @token

		# fire up an invoice 
		@client_ip = request.remote_ip  
		@i = Invoice.new(
			:buyer_ip=>@client_ip,
			:product_id =>@product.id,
			:credit_card_token=>@token,
			:price=>@product.price
		)
		if @i.save
			puts 'we saved the token'
			redirect_to :action=>'purchase_single_success', :layout=>false
		else
			puts 'we could not save the token'
			redirect_to :action=>'single_shop_with_credit_card', :layout=>false, :encrypted_link=>params[:encrypted_link]
		end
	end

	# for the single shop purchases
	def purchase_single_success
		render :layout=>false
	end

	###########################################################
	# Edit is the controller for the landing page of a user
	# who clicked on a link
	###########################################################
	def edit
		@product = Product.find(params[:id])
		@encrypted_link = make_encrypted_link(@product.encrypted_link)
		if @product.nil?
			@new = true
		end
	end

	###########################################################
	# Update is the controller for a user updating the link/
	# product he/she is trying to sell
	###########################################################
	def update
		@product = Product.find(params[:id])
		if @product.encrypted_link.nil?
	
			# encrypted link is just the product's id in
			# a base 36 encryption
			@product.encrypted_link = @product.id.to_s(36)
			@product.save

		end
			if @product.update_attributes(params[:product])
				flash[:success]="Updated!"
				redirect_to edit_company_product_path
			else
				flash[:error]="Failed to updated."
				redirect_to edit_company_product_path
			end
	end

	def preview
		render :layout => false
	end

	# GET 
	def show
		respond_to do |format|
			format.html
		end
	end


  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    @product.company_id = current_company.id

    if @product.save
			@product.encrypted_link = @product.id.to_s(36)
			if @product.save
				flash[:success] = "Submit Success!"
				redirect_to edit_company_product_path(current_company.id, @product.id )
			else
				flash[:error]="Product didn't save properly"
				render 'new'
			end
    else
			flash[:error]="Product didn't save"
     	render 'new'
    end
  end

  # Where we take people the first time they sign on
  def first_product
    @product = Product.new
  end

   def index
		redirect_to company_root_path
    #if params[:company_id]
    #  @company = Company.find(params[:company_id])
    #  @products = @company.products
    #else
    #  @products = Product.all
    #end
   end

	def destroy
		@product = Product.find(params[:id])
		@company_id = @product.company_id
	  @company = Company.find(@company_id)
  	@product.destroy

    redirect_to company_products_path(@company)
	end

    # Pulls a random product record from the database 
	# TODO: add filtering
	def random_api
		# get a random record number
		offset = rand(Product.count)
		# off set it
		rand_record = Product.first(:offset => offset)	
		# get the output in xml format
		@product = rand_record
		@path = root_url + 'system/pictures/'+@product.id.to_s+'/medium/'

		@no_token_error = {'message'=>'no token provided'}
		@invalid_token_error = {'message' => 'invalid token provided'}

		@user = User.new

		respond_to do |format|
			if params[:token].nil?
				puts "NO TOKEN ERROR"
				format.json { render :json=> @no_token_error}
			elsif Game.find_by_token(params[:token]).nil?
				puts "INVALID TOKEN ERROR"
				format.json { render :json=> @invalid_token_error}
			else
				@game = Game.find_by_token(params[:token])
				@game.increment!(:impressions) #increment impressions
				@game.earnings = @game.earnings + @product.price # pay the player by the cost of product
				@game.save

				@product.increment!(:displayed)
				#format.html {render :xml => @product}
				format.xml
				format.json
			end
		end
	end


	def update_product_api
		respond_to do |format|
			format.js do	
				@product = Product.find_by_id(params[:product_id])
				puts @product.name
				@product.increment!(:click_through)
				render :json=>"{'message':'OK'";
			end
		end
		
	end


	# displays a page of inventory
	def inventory_display
		# give a record number, display that may products random products
		@products = []

		#offset = rand(Product.count)
		# off set it
		#rand_record = Product.first(:offset => offset)
		for type in Type.all do
			rand_record = Product.find_by_product_type(type.name)
		    if rand_record
				rand_record['picture_path'] = picture_path_builder(root_url, rand_record) + rand_record.picture_file_name
				@products << rand_record
		    end
	    end
		render :layout => false
	end



	###########################################################
	# controls checkoutprocess for the store
	# need shipping address and credit card
	###########################################################
	def confirm_purchase
		if current_user.nil? and params[:user_id] == '-1'
			puts 'User ID doesnt exists, routing to make user register'
			redirect_to :controller=>'users',:action=>'product_user_prompt', :layout=>false, :product_id=>params[:product_id]
		# check if the user has a shipping address
		elsif current_user.shipping_addresses.count == 0
			# no shipping address!
			redirect_to :controller=>'shipping_addresses', :action=>'new', :layout=>false,:user_id => current_user.id, :product_id=>params[:product_id]
		# check if the user has a credit card
		elsif current_user.credit_card_token.nil?
			puts 'User credit card doesnt exists, routing to make user log credit card'
			@product_id = params[:product_id]	
			redirect_to :controller=>'users',:action=>'credit_card_new', :product_id=>@product_id,:layout=>false
		else
			# debug
			puts "Credit Card #{current_user.credit_card_token}"
			puts params[:user_id]
			puts 'Passed all test, lets confirm'
				
			@product = Product.find_by_id(params[:product_id])
			@product['picture_path'] = picture_path_builder(root_url, @product) + @product.picture_file_name
			@default_address = current_user.shipping_addresses.find_by_default(true)
			@user = current_user
			puts @user
			if current_user
				puts 'is logged in'
			end

			render :layout => false
		end
	end


	###########################################################
	# creates the invoice. basically the user has bought it
	###########################################################
	def confirm_purchase_create
		@i = Invoice.new(params[:invoice])
		if @i.save
			# TODO: send receipt email
			redirect_to :action=>'purchase_success', :layout=>false
		else
			render :layout=>false
		end
	end

	def api_purchase_create
		# user token doesn't exist
		# token is test case
		# token is invalid
		# token exists
		if params[:token].nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'a user token is required'}"}
			end
		end
		if params[:credit_card_token].nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'a credit card token is required'}"}
			end
		end
		if params[:product_id].nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'no product id'}"}
			end
		end
		@user = User.find_by_token(params[:token])
		@product = Product.find_by_id(params[:product_id])
		if @user.nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'your user token is invalid'}"}
			end
		end
		if @product.nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'product doesn't exist'}"}
			end
		end
		if @user.credit_card_token != params[:credit_card_token]
			respond_to do |format|
				format.json {render :json=>"{'error':'wrong credit card'}"}
			end
		end
		@s = @user.shipping_addresses.find_by_default(true)
		if @s.nil?
			respond_to do |format|
				format.json {render :json=>"{'error':'user doesn't have a shipping address'}"}
			end
		end
		@invoice = Invoice.new(
				:user_id =>@user.id,
				:product_id => @product.id,
				:shipping_address_id=> @s.id,
				:credit_card_token =>@user.credit_card_token,
				:price => @product.price
		)
		if @invoice.save
			# TODO: send receipt email
			respond_to do |format|
				format.json
			end
		else
			respond_to do |format|
				format.json {render :json=>"{'error':'failed to save invoice, please try again'}"}
			end
		end
	end

  # returns the most recent purchase
  def api_invoice_token
	# token doesn't exist
	# token is test case
	# token is invalid
	# token exists
	if params[:token].nil?
		respond_to do |format|
			format.json {render :json=>"{'error':'a user token is required'}"}
		end
	elsif params[:token] == '12345'
		@user = User.first
	elsif User.find_by_token(params[:token]).nil?
		respond_to do |format|
			format.json {render :json=>"{'error':'your user token is invalid'}"}
		end
	else	
		@user = User.find_by_token(params[:token])
		@invoice = Invoice.find_by_user(@user.id).last
		@product = @invoice.product_id

		if @invoice
			respond_to do |format|
				format.json
			end
		else
			respond_to do |format|
				format.json {render :json=>"{'error':'no invoice found'}"}
			end
		end
	end

  end
	

	# for the store
	def purchase_success
		render :layout=>false
	end

	def success_prompt
		render :layout => false
	end


    private 
        def is_a_number?(s)
            s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
        end

        def picture_path_builder(root_url, product)
            @path = root_url + 'system/pictures/'+ product.id.to_s+'/medium/'
        end	
				def make_encrypted_link(str)
					"#{root_url}g/#{str}"
				end
end
