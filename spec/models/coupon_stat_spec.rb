require 'spec_helper'

describe CouponStat do
  pending "add some examples to (or delete) #{__FILE__}"
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

