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

require 'spec_helper'

describe AdStat do
  pending "add some examples to (or delete) #{__FILE__}"
end
