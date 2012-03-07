class Game < ActiveRecord::Base
	belongs_to :publisher
	
	has_many :game_stats
	has_many :users, :through => :game_stats
	
validates_presence_of :name, :message => "needs your name"
	attr_accessible :name, :meta_data
end

# == Schema Information
#
# Table name: games
#
#  id           :integer(4)      not null, primary key
#  publisher_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  meta_data    :string(255)
#  name         :string(255)
#  token        :string(255)
#  impressions  :integer(4)      default(0)
#  earnings     :decimal(8, 2)   default(0.0)
#

