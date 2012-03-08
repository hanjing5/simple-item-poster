class Ad < ActiveRecord::Base
	include Math
	
	belongs_to :company
	
	has_many :ad_stats
	has_many :users, :through => :ad_stats

	has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100"}
	
	attr_accessible :company_id, :limit, :type, :name, :description, :cost_per_impression,
		:cost_per_click, :cost_per_purchase, :love_hate, :relief_fear, :excite_bore,	
		:happy_sad, :funny_serious, :sexy_disgust, :meta_data, :picture
	
	after_create :initialize_distance
	after_save :update_distance 
	
	# Find feature for API calls
	def self.find_by_magic( params )
		# We set an arbitrary tolerance of 10 units
		tolerance = 10 
		limit ||= params[:limit]
		limit ||= 5
		
		feelings = { :love_hate => 0, :relief_fear => 0, :excite_bore => 0, :happy_sad => 0, :funny_serious => 0, :sexy_disgust => 0 }
		params.each do |key, value|
			feelings[key] = value unless feelings[key].nil?
		end
		
		dist = 0
		feelings.each do |key, value|
			dist += value
		end
		
		internals = { :distance => dist }
		statement = "distance < :distance + #{dist} AND distance > :distance - #{dist}"
		Ad.where( statement, internals ).limit( limit ).order( "distance DESC" )
	end

	def view( user )
		as ||= self.ad_stats.find_by_user_id( user.id )
		as ||= self.ad_stats.create( :user_id => user.id )
		as.view
	end
	
	def click( user )
		as ||= self.ad_stats.find_by_user_id( user.id )
		as ||= self.ad_stats.create( :user_id => user.id )
		as.click	
	end
	
	def close( user )
		as ||= self.ad_stats.find_by_user_id( user.id )
		as ||= self.ad_stats.create( :user_id => user.id )
		as.close
	end
	
	private	
		def update_distance
			self.distance = ( self.love_hate.abs ) + ( self.relief_fear.abs ) + (  self.excite_bore.abs ) + ( self.funny_serious.abs ) + ( self.sexy_disgust.abs )		
		end
	
		def initialize_distance
			self.love_hate ||= 0
			self.relief_fear ||= 0
			self.excite_bore ||= 0
			self.happy_sad ||= 0
			self.funny_serious ||= 0
			self.sexy_disgust ||= 0
			update_distance
		end
end



# == Schema Information
#
# Table name: ads
#
#  id                   :integer(4)      not null, primary key
#  company_id           :integer(4)
#  limit                :integer(4)
#  type                 :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  description          :text
#  cost_per_impression  :integer(10)
#  cost_per_click       :integer(10)
#  cost_per_purchase    :integer(10)
#  love_hate            :integer(4)
#  relief_fear          :integer(4)
#  excite_bore          :integer(4)
#  happy_sad            :integer(4)
#  funny_serious        :integer(4)
#  sexy_disgust         :integer(4)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  meta_data            :text
#  distance             :integer(4)      default(0)
#

