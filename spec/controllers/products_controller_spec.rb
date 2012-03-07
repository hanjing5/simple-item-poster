require 'spec_helper'

describe ProductsController do
   describe "try random api" do
     it "should return a random product " do
       @expected = {
        :successful_login  => "true",
    }.to_json
       @game = Factory(:game)
       @product = Factory(:product)
       post :random_api, :token => 1, :format => :json

       response.body.should == @expected

     end
   end
end
