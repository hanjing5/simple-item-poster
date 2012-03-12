require 'spec_helper'

describe ProductStat do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: product_stats
#
#  id         :integer(4)      not null, primary key
#  impression :boolean(1)      default(FALSE)
#  purchase   :boolean(1)      default(FALSE)
#  product_id :integer(4)
#  company_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  ip         :string(255)
#

