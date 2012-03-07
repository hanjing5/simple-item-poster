class UsersController < ApplicationController

  before_filter :authorize_current_user, :except => [:index]

  def create_new_token
		(Digest::MD5.hexdigest "#{ActiveSupport::SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end

  def show
	@toolbar_hash = {:user => 'active' }
  	@user = User.find( params[:id] )
  end

  def new
	@toolbar_hash = {:user => 'active' }
  	@user = User.new
  end

  def index
	@toolbar_hash = {:user => 'active' }
	puts @toolbar_hash
	puts @toolbar_hash[:user]
	puts "is this right?"
  	@users = User.limit(150).paginate( :page => params[:page], :per_page => 10 )
  end

  def user_email_only_form
	@user = User.new
	render :layout => false
  end

  def user_email_only_create
	@user = User.new(params[:user])
	if @user.save
		# send email
		redirect_to :action=> "user_email_only_success"
	else 
		redirect_to :action=> "user_email_only_failure"
	end
  end

  def user_email_only_success
		render :layout => false
  end

  def user_email_only_failure
		render :layout => false
  end
	
	def product_user_prompt
		@product_id = params[:product_id]
		render :layout => false,:product_id => params[:product_id]
	end

  def product_user_sign_in
		render :layout => false
  end

  def product_user_register
		@product_id = params[:product_id]
		render :layout => false,:product_id => params[:product_id]
  end

	####################################################
	# HTML5 Modal
	####################################################
  def credit_card_new
		@product_id = params[:product_id]
		render :layout => false
  end

	####################################################
	# HTML5 Modal
	####################################################
  def credit_card_edit
		render :layout => false
  end
	####################################################
	# HTML5 Modal
	# create the credit and redirects use to the puchase
	# controller
	####################################################
  def credit_card_create
		Stripe.api_key = "9sir8teed4nvvwDoSOjBgy29k4pNy3iF"
		@user = current_user
		# get credit card info
		# send to stripe and/or store it through post call
		begin
			response = Stripe::Token.create(:card=>params[:card],:currency=>"usd")
		rescue StandardError => err
			# catch the errors that stripe throws
			flash[:error] = 'Credit card info errors. Please check your entry again.'
			puts err
			redirect_to :action=>'credit_card_new',:layout=>false, :product_id=>params[:product_id],:user_id=>params[:user_id]
			return
		end

		# catch token and store that
		token = response.zip[7][0][1]
		puts token
		# store the token in the user db
		@user.credit_card_token = token
		@product_id = params[:product_id]
		puts @user.credit_card_token
		if @user.save
			puts 'we saved the token'
			redirect_to :controller=>'products', :action=>'confirm_purchase', :layout => false,:user_id=>params[:user_id],:product_id=>params[:product_id]
		else
			puts 'we did not save the token'
			redirect_to :action=>'credit_card_new',:layout=>false, :product_id=>params[:product_id],:user_id=>params[:user_id]
		end
  end

	####################################################
	# RESTful API
	####################################################
  def api_credit_card_create	
		Stripe.api_key = "9sir8teed4nvvwDoSOjBgy29k4pNy3iF"
		# token doesn't exist
		# token is test case
		# token is invalid
		# token exists
		@success = false
		@message = ''
		@credit_card_token = ''
		if params[:user_token].nil?
			@message = 'a user token is required'
			respond_to do |format|
				format.json
			end
		elsif params[:user_token] == '12345'
			@user = User.first
		elsif User.find_by_token(params[:user_token]).nil?
			@message = 'your user token is invalid'
			respond_to do |format|
				format.json
			end
		else	
			@user = User.find_by_token(params[:user_token])
			# TODO: another check to see if the card number and cvc are all correct
			response = Stripe::Token.create(:card=>params[:credit_card],:currency=>"usd")
			# catch token and store that
			token = response.zip[7][0][1]
			# store the token in the user db
			@user.credit_card_token = token
			if @user.save
				@message = 'here is the token'
				@success = true
				respond_to do |format|
					format.json
				end
			else
				@message = 'something went wrong and the card token didnt save'
				respond_to do |format|
					format.json
				end
			end
		end
  end

	####################################################
	# RESTful API
	# This retrieves the token
	####################################################
  def api_credit_card_token
		Stripe.api_key = "9sir8teed4nvvwDoSOjBgy29k4pNy3iF"
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
			token = @user.credit_card_token
			if token
				respond_to do |format|
					format.json {render :json=>"{'card_token':token}"}
				end
			else
				respond_to do |format|
					format.json {render :json=>"{'error':'user doesnt have a credit card token'}"}
				end
			end
		end

  end

	####################################################
	# RESTful API
	# get user token by submitting a pair of username
	# password
	####################################################
  def api_login
    #convert what params we want to an info hash
    info = Hash["email" => params[:email], "password" => params[:password],"name" => params[:username] ,"game_token" => params[:game_token]]

    #check if the user is legit
	@user = user_check(info)
	# TODO: increment the appropriate info such as sign_in_counts and stuff
	if info["game_token"].nil? or Game.find_by_token(info["game_token"]).nil?
		@message = 'no or invalid game token'
		@success = "false"
		@user_token = ""
		respond_to do |format|
		  format.json
		end
	else
		if @user
			if @user.token.nil?
				# user has no token, we make one for him/her
				@user_tmp = User.find_by_email(params[:email])
				@user_tmp.token = create_new_token
				if @user_tmp.save
					@message = 'successfully logged in'
					@success = "true"
					@user_token = @user.token
					respond_to do |format|
					  format.json
					end
				else
					# token didn't save? something went wrong
					puts 'cant save token'
					@success = "false"
					@user_token = ""
					@message = @user_tmp.errors
					respond_to do |format|
					  format.json
					end
				end
			else
				# successfully logg in
				@success = "true"
				puts 'succcess!'
				@user_token = @user.token
				@message = 'successfully logged in'
				respond_to do |format|
				  format.json
				end
			end
		else
			# user provided the wrong email or password and can't log in
			@message = 'wrong username or password provided'
			@success = "false"
			@user_token = ""
			respond_to do |format|
			  format.json
			end
		end
	end
  end

	####################################################
	# RESTful API
	# create a user by submitting a pair of username
	# password
	# returns a token
	####################################################
  def api_user_create
	if params["game_token"].nil? or Game.find_by_token(params["game_token"]).nil?
		@message = 'no or invalid game token'
		@success = "false"
		@user_token = ""
		respond_to do |format|
		  format.json
		end
	else
		if User.find_by_email(params["email"])
			@message = "user already exists"
			@success = "false"
			@user_token = ""
			respond_to do |format|
			  format.json
			end
		else 
			@user = User.new(:email => params["email"],:password => params["password"],:name=>["name"] )
			
			if @user.save
				@user.token = create_new_token
				@user.save
				@message = "user created"
				@success = "true"
				@user_token = @user.token
				respond_to do |format|
				  format.json
				end
			else
				@message = @user.errors
				@success = "false"
				@user_token = ""
				respond_to do |format|
				  format.json 
				end
			end
		end
	end
  end
#  def after_sign_out_path_for(user)
#    api_v1_product_inventory_display_path
    #root_path
#  end


  private

		#check if the user is legit. 3 cases
		#1. If the email exists but the password is wrong. Return nil
		#2. if the user does not exist return nil
		#3. if the password is correct, return user
		def user_check(info)
			# no game token no log in (security reasons)
			if User.find_by_email(info["email"]).nil?
				puts 'no user by email'
				return nil
			end
					@user = User.find_by_email(info["email"])
			puts @user.email
			puts @user.password

			puts info["email"]
			puts info["password"]
			if @user.valid_password?(info["password"])
				puts 'password is correct!'
				return @user
			end
			return nil
		end
end
