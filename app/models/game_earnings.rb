class GameEarnings < ActiveRecord::Base
	# attr_accessible should only be allow once for seeding the datebase for created_at
  attr_accessible :game_id, :coupon_id, :earnings, :coupon_cost, :user_id
end

# == Schema Information
#
# Table name: game_earnings
#
#  id          :integer(4)      not null, primary key
#  game_id     :integer(4)
#  coupon_id   :integer(4)
#  earnings    :decimal(9, 2)   default(0.0)
#  coupon_cost :decimal(9, 2)   default(0.0)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

