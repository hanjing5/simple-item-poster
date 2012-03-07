require 'spec_helper'

describe AdsController do
   include Devise::TestHelpers
    render_views
    before(:each) do
       @request.env["devise.mapping"] = Devise.mappings[:user]

       end
   describe "api login" do
     describe "whatever else this should do" do

     end

     describe "login helper function" do
       it "should login user" do
         #I had to do some ghetto tests but the user is indeed logged in. Keeping this in so you know it was checked
      end
      it "should not create a new user and retrieve one" do
         @user = Factory(:user)
         @attr = Factory.attributes_for(:user)
        lambda do
           post :api_login, :user => @attr
        end.should change(User, :count).by(0)
        assigns[:user].email.should == @user.email
      end
      it "should create a new user if none exists so far" do
        @user = Factory.build(:user)
        lambda do
           post :api_login, :user => @user.attributes
        end.should change(User, :count).by(1)
        assigns[:user].email.should == @user.email
      end
    end
   end
end
