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

require 'spec_helper'

describe GameStat do
  pending "add some examples to (or delete) #{__FILE__}"
end
