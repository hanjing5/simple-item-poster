class ShippingAddressesController < ApplicationController
  def new
	@product_id = params[:product_id]
	render :layout => false
  end

  def show
  end
  def edit

  end

  def api_shipping_address_create	
	# user token doesn't exist
	# user token is test case
	# user token is invalid
	# user token exists
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

		params[:shipping_address][:user_id] = @user.id
		@s = ShippingAddress.new(params[:shipping_address])

		if @s.save
			# change this shipping address to the defaul
			p = @user.shipping_addresses.find_by_default(true)
			if p
				p.default = false
				p.save
			end
			s.default = true
			s.save

			respond_to do |format|
				format.json {render :json=>"{'success':'shipping address saved'}"}
			end
		else
			respond_to do |format|
				format.json {render :json=>"{'error':'something went wrong and your address didnt save'}"}
			end
		end
	end
  end

  def api_shipping_address_token
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
		@d = @user.shipping_addresses.find_by_default(true)
		
		if @d
			respond_to do |format|
				format.json
			end
		else
			respond_to do |format|
				format.json {render :json=>"{'error':'user doesnt have a default shipping address'}"}
			end
		end
	end

  end

  def create
		@user = User.find_by_id(params[:user_id])
		@product_id = params[:product_id]
		@user.shipping_addresses.new(params[:shipping_address])
		params[:shipping_addresses][:user_id] = params[:user_id]
		s = ShippingAddress.new(params[:shipping_addresses])

		if s.save
			# this is teh user's new default address
			p = @user.shipping_addresses.find_by_default(true)
			if p
				p.default = false
				p.save
			end
			s.default = true
			s.save

			redirect_to :controller=>'products',:action=>'confirm_purchase', :product_id=>@product_id,:layout=>false
		else
			flash[:error] = 'Something is entered incorrectly. Please check your entry again.'
			redirect_to :action=>'new', :product_id=>@product_id
		end
  end

end
