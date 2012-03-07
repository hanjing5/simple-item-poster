class State < ActiveRecord::Base
	attr_accessible :state
end

# == Schema Information
#
# Table name: states
#
#  id         :integer(4)      not null, primary key
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

