class CouponStat < ActiveRecord::Base
	belongs_to :coupon
	belongs_to :user

	# NOTE: make sure :created_at is here if you want rake db:seed
	# to run correctly
	attr_accessible :click_through, :impression, :game_id, :user_id
end


# == Schema Information
#
# Table name: coupon_stats
#
#  id            :integer(4)      not null, primary key
#  coupon_id     :integer(4)
#  user_id       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  game_id       :integer(4)
#  click_through :boolean(1)      default(FALSE)
#  impression    :boolean(1)      default(FALSE)
#

