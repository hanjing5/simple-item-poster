class ProductStat < ActiveRecord::Base
	belongs_to :product
	belongs_to :company

	# NOTE: make sure :created_at is here if you want rake db:seed
	# to run correctly
	attr_accessible :purchase, :impression, :product_id, :company_id, :ip
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

