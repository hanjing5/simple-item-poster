# == Schema Information
#
# Table name: game_stats
#
#  id               :integer(4)      not null, primary key
#  game_id          :integer(4)
#  user_id          :integer(4)
#  plays            :integer(4)
#  duration_average :integer(10)
#  created_at       :datetime
#  updated_at       :datetime
#

class GameStat < ActiveRecord::Base
	belongs_to :game
	belongs_to :user
end
