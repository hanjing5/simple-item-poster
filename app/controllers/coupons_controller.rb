class CouponsController < ApplicationController

	# use this or add protect_from_forger :except=> :create
	skip_before_filter :verify_authenticity_token, :except => [:create, :destroy, :update]

	# PUT request, xml for the api
	def update
		# 2 modes of operation
		respond_to do |format|
			format.html do
				# TODO: write me!
			end
			
			format.xml do
				# TODO: write me!
			end
		end
	end

	# GET 
	def show
		
		if params[:random] == 'true'
		  # get a random coupon through count and offset
		  @coupon = Coupon.first(:offset => rand(Coupon.count))
		  @company = Company.find(@coupon.company_id)
    	elsif params[:company_id] and params[:id]
	      @coupon = Coupon.find(params[:id])
	      @company = Company.find(params[:company_id])
		elsif params[:coupon_id] and is_a_number?(params[:coupon_id])
		  # this needs a proper resuce if we can't find the right coupon
		  @purpose = params[:xml]
		  @coupon = Coupon.find(params[:coupon_id]) 
		  @company = Company.find(@coupon.company_id)
		elsif params[:coupon_name]
		  # this needs a proper resuce if we can't find the right coupon
		  @purpose = params[:xml]
		  @coupon = Coupon.find_by_name(params[:coupon_name]) 
		  @company = Company.find(@coupon.company_id)
		end
		# build the picture path, this should probably be put somewhere else		
		@path = picture_path_builder(root_url, @coupon)

		respond_to do |format|
			format.xml
			format.html
      format.json
		end
	end


    def new
		@coupon = Coupon.new
    end

    def create
		@coupon = Coupon.new(params[:coupon])
		@coupon.company_id = current_company.id

		if @coupon.save
			flash[:success] = "Submit Success!"
			redirect_to :action => 'index', :params => {:company_id => @coupon.company_id}
		else 
			render 'new'
		end
		
    end

   def index
	puts "INDEX CALLED"
    if params[:company_id]
      @company = Company.find(params[:company_id])
      @coupons = @company.coupons
    else
      @coupons = Coupon.all
    end
     respond_to do |format|
			format.html
			format.xml
		end
   end

	def destroy
		@coupon = Coupon.find(params[:id])
		@company_id = @coupon.company_id
    @company = Company.find(@company_id)
  		@coupon.destroy
 

    	 redirect_to company_coupons_path(@company)

	end

	# thanks for the nice comments
	# rapid API requests
    # Pulls a random coupon record from the database 
	# TODO: add filtering
	def random_api

		respond_to do |format|
			if params[:token].nil?
				puts "NO TOKEN ERROR"
				@success = false
				@message = 'no token provided'
				format.json {render :json=>"{'message':#{@message}, 'success':#{@success}}"}
			elsif Game.find_by_token(params[:token]).nil?
				puts "INVALID TOKEN ERROR"
				@success = false
				@message = 'invalid token provided'
				format.json {render :json=>"{'message':#{@message}, 'success':#{@success}}"}
			else
				# get a random record number
				offset = rand(Coupon.count)
				# off set it
				rand_record = Coupon.first(:offset => offset)	
				# get the output in xml format
				@coupon = rand_record
				@path = root_url + 'system/pictures/'+@coupon.id.to_s+'/medium/'
				@user = User.new
				@game = Game.find_by_token(params[:token])
				
				# increments impression
				@coupon.coupon_stats.create(:game_id=>@game.id, :impression => 1 )
				@success = true
				@message = 'coupon shown'

				format.xml
				format.json
			end
		end
	end

	def is_a_number?(s)
		s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

	def update_coupon_api
		if params[:coupon_id].nil? or params[:token].nil?
			@success = false
			@message = 'missing game token or coupon id'
			respond_to do |format|
				format.js
				format.json
				return 
			end
		end
		
		@coupon = Coupon.find_by_id(params[:coupon_id])
		@game = Game.find_by_token(params[:token])
		if @coupon and @game
			respond_to do |format|
				@success = true
				@message = 'success'
			
				format.js do	
					@coupon.coupon_stats.create(:game_id=>@game.id, 
						:click_through => 1 )
					render :json=>"{'success': 'true', 'message':'SUCCESS'}";
				end
				format.json
			end
		else
			@success = false
			@message = 'wrong game token or coupon id'
			
			respond_to do |format|
				format.js
				format.json
				return 
			end
		end
		
	end

	def picture_path_builder(root_url, coupon)
		@path = root_url + 'system/pictures/'+ coupon.id.to_s+'/medium/'
	end	

end
