class Pic < ActiveRecord::Base
	belongs_to :company

	has_attached_file :picture_link, :styles => {:medium => "250x250", :thumb=>"50x50"}
end


# == Schema Information
#
# Table name: pics
#
#  id                        :integer(4)      not null, primary key
#  content                   :text
#  meta_data                 :text
#  created_at                :datetime
#  updated_at                :datetime
#  name                      :string(255)
#  product                   :integer(4)
#  company_id                :integer(4)
#  cost_per_redeem           :integer(4)
#  limit                     :integer(4)
#  redeemed                  :integer(4)
#  picture_link_file_size    :integer(4)
#  picture_link_file_name    :string(255)
#  picture_link_updated_at   :datetime
#  picture_link_content_type :string(255)
#

