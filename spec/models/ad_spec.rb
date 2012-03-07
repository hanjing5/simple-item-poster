require 'spec_helper'

describe Ad do
  pending "add some examples to (or delete) #{__FILE__}"
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
#  picture_file_size    :integer(4)
#  picture_file_name    :string(255)
#  picture_updated_at   :datetime
#  picture_content_type :string(255)
#  meta_data            :text
#  distance             :integer(4)      default(0)
#

