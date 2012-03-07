class TmpUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token # HIGH SECURITY RISK!

  def show
    @token = params[:token]
	@coupon_id = params[:coupon_id]


	render :layout => false
  end

	def success
		render :layout=>false
	end

	def failure
		render :layout=>false
	end
  def redeemed_to_soon
    #the coupon was redeemed to soon.
    #look up the coupon_stats to find out how long the user has until he can reclaim same coupon again.
    @coupon_stat_id = params[:coupon_stat]
    @coupon_stat = CouponStat.find(@coupon_stat_id)
    render :layout=>false
  end

  def create
		respond_to do |format|
			# Convert post requests to the right format for standardization
			# tmp_user: {email:value, token:value ... 
			# to 
			# tmp_user: {email:value ... }, email:value, token:value ...
			if not(params[:tmp_user].nil?)
				params[:email] = params[:tmp_user][:email]
				params[:token] = params[:tmp_user][:token]
				params[:coupon_id] = params[:tmp_user][:coupon_id]
			end

			if params[:email].nil? or params[:coupon_id].nil? or params[:token].nil?
				puts 'One of the arguments is missing'
				custom_response format, 'failure', "arguments missing or invalid"
			elsif Coupon.find_by_id(params[:coupon_id]).nil? or Game.find_by_token(params[:token]).nil?
				puts 'Wrong token or coupon_id'
				custom_response format, 'failure', "arguments missing or invalid"
			elsif not is_valid_email(params[:email])
				puts 'Wrong token or coupon_id'
				custom_response format, 'failure', "email is not valid"
			else
				@coupon = Coupon.find_by_id(params[:coupon_id])
				@game = Game.find_by_token(params[:token])
				#check to see if this user has existed before
				#NOTE: coupon_id and game_id is not used for anything
				#if this should be part of the logic changes should be made

				info = Hash["email" => params[:email], "coupon" => params[:coupon_id], "game" => @game.id]
				@user = temp_user_login(info)

				@company = Company.find_by_id(@coupon.company_id)
				@coupon_stat = @coupon.coupon_stats.find_by_user_id(@user.id)
				@game.earnings += @coupon.cost_per_redeem

				# redeemed only if the user is alright and the coupon hasn't been recently redeemed
				if @user.save && !@coupon.recently_redeemed(@user.id)
					@coupon.increment!(:redeemed)
					#@coupon.redeem(@user.id)
					# send email out
					@coupon[:picture_url] = picture_path_builder(root_url, @coupon)
					CouponMailer.welcome_email(@user).deliver
					CouponMailer.coupon_email(@user, @coupon).deliver
			
					# create an earnings record
					@gameEarnings = GameEarnings.new(
						:game_id=>@game.id, 
						:coupon_id=>@coupon.id, 
						:earnings=>@coupon.cost_per_redeem, 
						:coupon_cost => @coupon.cost_per_redeem, 
						:user_id=>@user.id
					)
					@gameEarnings.save

					custom_response(format, 'success', 'success')

					#this coupon was recently reclaimed by this temp user.
					#tell him so
					elsif @coupon.recently_redeemed(@user.id)
						format.html {redirect_to :action=>'redeemed_to_soon',:coupon_stat => @coupon_stat}
						format.xml
						format.json {render :json => {"message"=>"failure"}}
					else
						#puts "User Can't save?"
						#failure "unknown error"
						custom_response(format, 'failure', 'failure')
					end
				end
			end
			# lazy "KISS principle" method to respond to failed requests
	end
	def picture_path_builder(home_path, coupon)
		@path = home_path + 'system/pictures/'+ coupon.id.to_s+'/medium/'
	end	

  private

  #Checks to see if the temp user exists.
  #if the temp user exists then use that, otherwise we'll create a tmp account for him
  #we store the coupon_id and game id for some reason, not sure why.
		def temp_user_login(info)
			unless TmpUser.find_by_email(info["email"]).nil?
				@user = TmpUser.find_by_email(info["email"])
				return @user
			else
				@user = TmpUser.create(:email => info["email"],:coupon_id => info["coupon"], :game_id => info["game"] )
				return @user
			end
		end

		def custom_response(format, action, msg)
			@success = true
			if action == 'failure'
				@success = false
			end
				format.html {redirect_to :action=>action}
				format.xml
				format.json {render :json => {"success"=>@success, "message"=>msg}}
		end

		def is_valid_email(email)
			return email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
		end
end
