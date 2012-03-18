class ProductsController < ApplicationController

	require 'digest/md5'
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

		# prepare the picture
		@product['picture_path'] = ''
		
		# simple impression increment
		@product.increment!(:displayed)

		# sophisticated stats database increment
		create_stats(@product, :impression)

		if @product.picture_file_name
			@product['picture_path'] = picture_path_builder(@product) + @product.picture_file_name
		end
		render :layout => false	
	end

	###########################################################
	# format.js just do a ajax/jquery call to show the credit 
	# card form
	# Just in case user does not have javascript enabled
	# we show a new page with the credit card form shown already
	###########################################################
	def single_shop_with_credit_card

		# sophisticated stats database increment
		create_stats(@product, :click_through)

		respond_to do |format|
			format.js do
				@product = Product.find(params[:product_id].to_i(32))
				return
			end
			format.html do
				@product_id = params[:encrypted_link].to_i(32)
				@product = Product.find(@product_id)
				@product.increment!(:displayed)
				@product['picture_path'] = ''
				if @product.picture_file_name
					@product['picture_path'] = picture_path_builder(@product) + @product.picture_file_name
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
			:email => params[:card][:email],
			:buyer_ip=>@client_ip,
			:product_id =>@product.id,
			:credit_card_token=>@token,
			:price=>@product.price
		)


		if @i.save
			puts 'we saved the token'
			# we pass the invoice id so purchase single success have a way to get the invoice
  		@digest = Digest::MD5.hexdigest("#{@i.id}#{@i.credit_card_token}#{params[:encrypted_link]}#{@i.created_at}")
			
			# increment simple reporting
			@product.increment!(:purchased)
			# sophisticated stats database increment
			create_stats(@product, :purchase)

			redirect_to :action=>'purchase_single_success', :layout=>false, :id=>@i.id.to_s(32), :encrypted_link=>params[:encrypted_link], :success => @digest
		else
			puts 'we could not save the token'
			redirect_to :action=>'single_shop_with_credit_card', :layout=>false, :encrypted_link=>params[:encrypted_link]
		end
	end

	# for the single shop purchases
	def purchase_single_success		
		@i = Invoice.find(params[:id].to_i(32))
  	@digest = Digest::MD5.hexdigest("#{@i.id}#{@i.credit_card_token}#{params[:encrypted_link]}#{@i.created_at}")
		if @digest = params[:success]
			@product = Product.find(params[:encrypted_link].to_i(32))
			@downloadables = @product.attachments.all
			if @downloadables
				@downloadables.each do |downloadable|
					downloadable['download_path'] = downloadable_path_builder(downloadable)+ downloadable.file_file_name
					puts downloadable['download_path']
				end
			end
			if @product.picture_file_name
				@product['picture_path'] = picture_path_builder(@product) + @product.picture_file_name
				@product['download_path'] = download_path_builder(@product) + @product.picture_file_name
			end
			render :layout=>false
			return
		else
			redirect_to root_url
		end
	end


 	def download
		@product = Product.find(params[:encrypted_link].to_i(32))
		@product['picture_path'] = picture_path_builder(@product) + @product.picture_file_name
		@product['download_path'] = download_path_builder(@product) + @product.picture_file_name
    #send_file "#{@product.picture_path}", :type=>"image/jpeg" 
		#require 'net/http'

		#Net::HTTP.start('0.0.0.0:3000') { |http|
		#	resp = http.get(@product['download_path'])
		#	open("fun.jpg", "wb") { |file|
		#		file.write(resp.body)
		#	 }
		#}
		#puts "Yay!!"
  end

	###########################################################
	# Edit is the controller for the landing page of a user
	# who clicked on a link
	###########################################################
	def edit
		@product = Product.find(params[:id])
		@downloadables = @product.attachments.all
		if @downloadables
			@downloadables.each do |downloadable|
				downloadable['download_path'] = downloadable_path_builder(downloadable)+ downloadable.file_file_name
				puts downloadable['download_path']
			end
		end
		
		@total_file_size = get_total_file_size(current_company)
	
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
		
		# sub section, delete product only
		if params['delete_attachment']
			@a = Attachment.find_by_id(params['delete_attachment'])
			@attachment_name = @a.file_file_name
			# paperclip delete file at path
			@a.file=nil
			# delete the record of the attachment
			if @a.save and @a.delete
				flash[:success]="Attachment #{@attachment_name} successfully deleted."
				return redirect_to edit_company_product_path
			else
				flash[:error]="Failed to delete #{@attachment_name}. Please try again."
				return redirect_to edit_company_product_path
			end
		end

		# prepare the attachment
		if params['attachment']
			# loop through all the attachments
			params['attachment'].each do |k, v|
				puts v	
				@file = Attachment.new({'file'=>v})
				@file.product_id = @product.id
			
				# check attachment size, if the user has over 100 total mb total
				# do not allow upload
				@file_size = @file.file_file_size
				@current_file_sizes = get_total_file_size(current_company)
				@file.save
				
			end
		end

		if @product.encrypted_link.nil?
	
			# encrypted link is just the product's id in
			# a base 36 encryption
			@product.encrypted_link = @product.id.to_s(36)
			@product.save

		end
			if @product.update_attributes(params[:product])
				flash[:success]="Update Success!"
				redirect_to edit_company_product_path
			else
				flash[:error]="Failed to updated!"
				redirect_to edit_company_product_path
			end
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
			# add the attachments first
			puts params['attachment']
			if params['attachment']
				params['attachment'].each do |k, v|
					puts v	
					puts
					@file = Attachment.new({'file'=>v})
					@file.product_id = @product.id
					puts
					
					@file.save
				end
			end

			@product.encrypted_link = @product.id.to_s(36)
			if @product.save
				flash[:success] = "Success! Shop created. Share the link on the right to start selling."
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
	end

	#################################################
  # destroy/delete the product
	#################################################
	def destroy
		@product = Product.find(params[:id])
		@company_id = @product.company_id
	  @company = Company.find(@company_id)
		
		# kill the attachments first
		@product.attachments.each do |a|
			# delete the actual file
			a.file=nil
			a.save
			# delete the record of the attachment
			a.delete
		end

  	@product.destroy
		flash[:success] = "#{@product.name} deleted."
    redirect_to company_products_path(@company)
	end

	#################################################
  # Pulls a random product record from the database 
	# TODO: add filtering
	#################################################
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
				rand_record['picture_path'] = picture_path_builder(rand_record) + rand_record.picture_file_name
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
			@product['picture_path'] = picture_path_builder(@product) + @product.picture_file_name
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

        def picture_path_builder(product)
            @path = root_url + 'system/pictures/'+ product.id.to_s+'/medium/'
        end
	
        def download_path_builder(product)
            @path = '/system/pictures/'+ product.id.to_s+'/original/'
        end	

				###########################################################
				# the crazy amount of variables that you see is due to me crunched on time
				# currently the location of the folder being stored is (i think) based on a 
				# size 9 integer divided in groups of 3 (i.e.: /000/001/234/ or /000/000/012/)
				###########################################################
        def downloadable_path_builder(downloadable)
						@length = 9
						@tmp = @length - downloadable.id.to_s.size
						@p = ''
						@t = 1
						while @t <= @tmp
							if @t % 3 == 0 and @t != 0
								@p += '0/'
							else
								@p += '0'
							end
							@t+=1
						end
						@p = @p + downloadable.id.to_s
            @path = '/system/attachments/files/' + @p +'/original/'
        end	

				def make_encrypted_link(str)
					"#{root_url}g/#{str}"
				end

				def create_stats(product, symbol)
					@ip = request.remote_ip
					ProductStat.create!(
						:product_id => product.id,
						:company_id => product.company_id,
						:ip => @ip,
						symbol => true
					)
				end
			
				def get_total_file_size(c)
					@size = 0
					c.products.each do |p|
						p.attachments.each do |a|
							@size += a.file_file_size
						end
					end 
					return @size
				end
end
