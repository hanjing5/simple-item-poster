class ShippingAddress < ActiveRecord::Base
	belongs_to :user

	attr_accessible :address1, :address2, :city, :zip, :state, :user_id, :default
	validates_presence_of :address1, :city, :zip, :state, :user_id
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

