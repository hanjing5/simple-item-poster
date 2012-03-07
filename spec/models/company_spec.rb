# == Schema Information
#
# Table name: companies
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe Company do
 it "should create right" do
   lambda do
     @company = Factory(:company)
   end.should change(Company, :count).by(1)
   @company.id.should == 1

 end

end
