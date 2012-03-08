class Coupon < ActiveRecord::Base
	belongs_to :company
	
	has_many :coupon_stats
	has_many :users, :through => :coupon_stats


	has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	
	attr_accessible :company_id, :name, :description, :cost_per_redeem, :limit, :redeemed, :ext_coupon_id, :meta_data, :picture
	
	def redeem(user_id)
		cs ||= self.coupon_stats.find_by_user_id( user_id)
		cs ||= self.coupon_stats.create( :user_id => user_id )
		cs.redeem
	end

  #look at this coupons stats and see if the user has recently redeemed it.
  def recently_redeemed(user_id)
	# We allow Han's email (or any other test emails really) through
	
	@user = TmpUser.find_by_id(user_id)
	if @user.email = 'hanqijing@gmail.com'
		return false
	end

    #get all stats with the user. There should only be one though, I'm not sure why i'm looking
    # for multiple. For now i'll assume i had reason to and leave it like this =D
	
    recent_coupon = self.coupon_stats.find_all_by_user_id(user_id,:order => "created_at DESC").first()
    #if we found any couponstats for that user.
    if recent_coupon
      #Check if the current time is past the allowed time for redeeming another coupon!
      if (Time.now >recent_coupon.updated_at + 1.days )
         return false
      else
          return true
      end
  #user has never before redeemed this coupon. He's cool
  else
    return false
  end

  end
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

