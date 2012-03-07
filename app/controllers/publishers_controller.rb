class PublishersController < ApplicationController
  def show
	@toolbar_hash = {:publisher => 'active'}
	@games = current_publisher.games
	@games_count = @games.count
	
	@earnings_count = 0
	@games.each do |g|
		r = GameEarnings.select(
				"SUM(earnings) as earnings").where(
				"game_id = #{g.id}").first.earnings
		if not r.nil?
			@earnings_count += r
		end
	end
	
	@im_count = 0
	@games.each do |g|
		r = CouponStat.select(
				"SUM(impression) as im").where(
				"game_id = #{g.id}").first.im
		if not r.nil?
			@im_count += r
		end
	end

	if current_publisher.token.nil?
		@token = create_new_token
	else
		@token = current_publisher.token
	end
  end
	def new_token
		@token = create_new_token
		redirect_to :action => "show"
	end

	def create_new_token
		string = (Digest::MD5.hexdigest "#{ActiveSupport::SecureRandom.hex(10)}-#{DateTime.now.to_s}")
		current_publisher.token = string
		current_publisher.save!
		return string
	end

  def new
	@toolbar_hash = {:publisher => 'active'}
  end

  def index
	@toolbar_hash = {:publisher => 'active'}
  end

end
