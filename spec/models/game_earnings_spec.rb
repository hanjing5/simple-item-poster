require 'spec_helper'

describe GameEarnings do
  pending "add some examples to (or delete) #{__FILE__}"
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

