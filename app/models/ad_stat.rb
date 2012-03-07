# == Schema Information
#
# Table name: ad_stats
#
#  id         :integer(4)      not null, primary key
#  ad_id      :integer(4)
#  user_id    :integer(4)
#  views      :integer(4)
#  clicks     :integer(4)
#  closes     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class AdStat < ActiveRecord::Base
	belongs_to :user
	belongs_to :ad
	
	def view
		self.views ||= 0
		self.views += 1
		self.save!
	end
	
	def click
		self.clicks ||= 0
		self.clicks += 1
		self.save!
	end
	
	def close
		self.closes ||= 0
		self.closes += 1
		self.save!
	end
end
