require 'spec_helper'

describe UsersController do

describe "it should return api login correctly" do

  it "should return json " do
     @expected = {
        :successful_login  => "true",
    }.to_json
    @user = Factory(:user)
    @attr = Factory.attributes_for(:user)
    post :api_login, :email => @attr[:email],:password =>@attr[:password], :format => :json
    assigns[:successful_login].should == "true"
    assigns[:user_token].should_not == "123345"
    #parsed_body = JSON.parse(response.body)
   # parsed_body[:user_token].should == false
  end
end

end
