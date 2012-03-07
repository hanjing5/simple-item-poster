class ShippingAddress < ActiveRecord::Base
	belongs_to :user

	attr_accessible :address1, :address2, :city, :zip, :state, :user_id, :default
	validates_presence_of :address1, :city, :zip, :state, :user_id
end
