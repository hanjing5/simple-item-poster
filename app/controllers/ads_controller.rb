class AdsController < ApplicationController
	respond_to :json
	# GET 
	def index
		@magic = params[:api]
		# @ads ||= Ad.find_by_magic( @magic ) unless @magic.nil?
		if params[:company_id]
		  @company = Company.find(params[:company_id])
		  @ads = @company.ads
		  @ads ||= Ad.all
		else
		  @ads ||= Ad.all
		end
		
		respond_to do |format|
			format.html
			format.xml
			format.json { respond_with @ads }
		end
	end
  
  def show
		@ad = Ad.find(params[:id])
		@ad.view( active_user ) unless current_company
		@company = @ad.company
		
		respond_to do |format|
			format.html
			format.xml
      format.json
		end
	end
	
	def new
		@company = Company.find(params[:company_id])
		@ad = @company.ads.new
	end

	def create
		@company = Company.find( params[:company_id] )
		@ad = @company.ads.create( params[:ad] )
        if @ad.save!
            flash[:success] = "Submit Success!"
            redirect_to [@company, @ad]
        else
            render 'new'
        end
	end
	
	# GET page for edit
	def edit
	
	end
	
	# PUT for update (also API calls)
	def update
		respond_to do |format|
			format.html do
				# Human HTML operation mode
				@ad = Ad.find( params[:id] )
				@ad.update_attributes params[:ad]
				if @ad.save!
					flash[:success] = "update successful"
					redirect_to company_ad_path @ad
				else
					flash[:error] = "update failed"
					render "edit"
				end
			end
			
			format.xml do
				# API call operation mode (see the users_helper.rb file)
				@user = api_find_or_create_user( params[:api][:user] )
				@ad = Ad.find(params[:api][:ad_id])
				@action = params[:api][:action]
				case @action
					when "click"
						@ad.click @user
					when "close"
						@ad.close @user
				end
				redirect_to company_ad_path @ad, :format => "xml"
			end
		end	
	end
	
	# DELETE for killing
	def destroy
    @ad = Ad.find(params[:id])
      @company_id = @ad.company_id
      @company = Company.find(@company_id)
        @ad.destroy

       redirect_to company_ads_path(@company)

	end
  def api_login

    login
    @user = current_user

  end
end
