require 'spec_helper'

describe Coupon do
  pending "add some examples to (or delete) #{__FILE__}"
end



# == Schema Information
#
# Table name: coupons
#
#  id                   :integer(4)      not null, primary key
#  company_id           :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  description          :text
#  limit                :integer(4)
#  redeemed             :integer(4)      default(0)
#  ext_coupon_id        :integer(4)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  meta_data            :text
#  cost_per_redeem      :decimal(8, 2)   default(0.0)
#  displayed            :integer(4)      default(0)
#  click_through        :integer(4)      default(0)
#

