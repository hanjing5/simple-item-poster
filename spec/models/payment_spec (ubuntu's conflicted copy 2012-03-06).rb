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

require 'spec_helper'

describe Payment do
  pending "add some examples to (or delete) #{__FILE__}"
end
