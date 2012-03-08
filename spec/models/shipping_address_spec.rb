require 'spec_helper'

describe ShippingAddress do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: shipping_addresses
#
#  id         :integer(4)      not null, primary key
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  default    :boolean(1)      default(FALSE)
#

