class GamesController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]

	def create_new_token
		(Digest::MD5.hexdigest "#{ActiveSupport::SecureRandom.hex(10)}-#{DateTime.now.to_s}")
	end

	def new_token
		@token = create_new_token
		g = Game.find(params[:game_id])
		g.token = @token
		g.save
		
		redirect_to :action => "show", :id =>g.id
	end

    def new
            @game = Game.new
    end

    def create
		@game = Game.new(params[:game])
		@game.publisher_id = current_publisher.id
		@game.token = create_new_token

		if @game.save
			flash[:success] = "Submit Success!"
			redirect_to :action => 'index', :params => {:publisher_id => @game.publisher_id}
		else 
			render 'new'
		end
		
    end

   def index
		@publisher = Publisher.find(params[:publisher_id])
		@games = @publisher.games
		
		respond_to do |format|
			format.html
		end
   end

	def destroy
		@game = Game.find(params[:id])
		@publisher_id = @game.publisher_id
  		@game.destroy
 
		respond_to do |format|
    			#format.html { redirect_to "index" }
			format.html { redirect_to :action => 'index', :params => {:publisher_id => @publisher_id} }
    			format.json { head :ok }
  		end
	end

	def update
	    @game = Game.find(params[:id])
	    if @game.update_attributes(params[:game])
    		  flash[:success] = "Profile updated."
		      redirect_to :action => 'index'
	    else
	      @title = "Edit Game"
	      render :action => 'update'
    end	

	end

	def show
		@game = Game.find(params[:id])
		################################################
		# Earning Data Constructs
		################################################
		@daily_earnings = GameEarnings.select("sum(earnings) as daily_earning, created_at").where("game_id='#{@game.id}'").group("date(created_at)")

		@fivedays = sumEarnings(GameEarnings.select("sum(earnings) as earning").where("game_id='#{@game.id}'").group("date(created_at)").limit("5"))
		
		@thirtydays = sumEarnings(GameEarnings.select("sum(earnings) as earning").where("game_id='#{@game.id}'").group("date(created_at)").limit("30"))
		@totaldays = GameEarnings.select("sum(earnings) as earning").where("game_id='#{@game.id}'").first.earning || 0
		################################################

		################################################
		# IMCT(Impression/Click_Through Data Constructs)
		################################################
		@daily_imct = CouponStat.select(
				"sum(impression) as impressions, sum(click_through) as cts, created_at"
			).where(
				"game_id='#{@game.id}'"
			).group(
				"date(created_at)"
			)
		# private method (# of days, game id, impression? or click_through?)
		@fivedays_im = coupon_record_from_past_days(5,  @game.id, 'impression').first.cnt
		@thirtydays_im = coupon_record_from_past_days(30,  @game.id, 'impression').first.cnt
		@totaldays_im = coupon_record_from_past_days('all',  @game.id, 'impression').first.cnt
		
		@fivedays_ct = coupon_record_from_past_days(5,  @game.id, 'click_through').first.cnt
		@thirtydays_ct = coupon_record_from_past_days(30,  @game.id, 'click_through').first.cnt
		@totaldays_ct = coupon_record_from_past_days('all',  @game.id, 'click_through').first.cnt
		################################################

		################################################
		################################################

		@visible_start_date = Time.now
		@visible_end_date = Time.now - 5.days

   		respond_to do |format|
			format.html
		end
	end

	def edit
		@game = Game.find(params[:id])
		@title = "Edit Game"
	end

	def is_a_number?(s)
		s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

  private

    def authenticate
      deny_access unless signed_in?
    end
	
	def coupon_record_from_past_days(n, game_id, type)
		#SELECT count(impression) FROM coupon_stats WHERE date_sub(curdate(), INTERVAL 5 DAY) <= created_at AND NOW() >= created_at AND game_id = 1 AND impression = 1;
		if n == 'all'
		 	CouponStat.select("count(#{type}) as cnt"
				).where(
					"game_id = #{game_id}
					AND #{type} = 1"
				)
		else
		
			CouponStat.select("count(#{type}) as cnt"
				).where(
					"date_sub(curdate(), INTERVAL #{n} DAY) <= created_at 
					AND NOW() >= created_at 
					AND game_id = #{game_id}
					AND #{type} = 1"
				)
		end
	end
	def sumEarnings(l)
			result = 0
			l.each do |g|
				result += g.earning
			end
			return result
	end


end
