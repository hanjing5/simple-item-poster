require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe UsersHelper do
   describe "active user" do
     it "should return right user " do
       @user = Factory.create(:user)
       @user.should equal(helper.active_user)
     end
   end

  describe "api find user" do
    before(:each) do
      @user = Factory.create(:user)
    end
    it "should return user if found" do
      @valid_info = Hash[:email => @user.email,:password => @user.password, :username => @user.username]
      helper.api_find_or_create_user(@valid_info).should == @user
    end

    it "should make user if not found" do
       @invalid_info = Hash[:email => "someuser@email.com", :password => "newpassword", :username => "second_user"]
      @newuser = helper.api_find_or_create_user(@invalid_info)
      @newuser.should_not == @user
      @newuser.email.should == @invalid_info[:email]

    end

    it "should return nil if password is incorrect" do
      @invalid_password = Hash[:email => @user.email,:password => "wrongpassword"]
      helper.api_find_or_create_user(@invalid_password).should be_nil
    end
  end
end
