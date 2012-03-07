# == Schema Information
#
# Table name: payments
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  method     :string(255)
#  info       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Class stores information on credit cards and other such critical information
class Payment < ActiveRecord::Base
	attr_accessible :user_id, :method, :info
	belongs_to :user
	
	# We don't fuck around here
	def self.create_magic( params )
		@method ||= params[:method]
		return false if @method.nil?
		
		@user ||= User.find(params[:user_id])
		prev_user = User.last
		@user ||= User.create( :name => "#{prev_user.id+1}",
			 :email => "#{prev_user.id+1}@ingidio.com", 
			 :password => "01j301jt01j0j1jg0n0n04ng0412t124g", 
			 :password_confirmation => "01j301jt01j0j1jg0n0n04ng0412t124g" ) 
			 
		case @method
			when "mastercard"
				year = params[:year]
				month = params[:month]
				card_number = params[:card_number]
				confirm_number = params[:confirmation]
				name = params[:name]
				
				# TODO: write stuff to test data
				
				info = [card_number, confirmation, name, year, month].join( "*|*")
				
			when "visa"
			
			# TODO: add stuff to handle other payment cases
		end
		@payment = Payment.create!( :info => info, :user_id => @user.id, :method => @method )
		
	end
	
end
