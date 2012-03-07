require 'spec_helper'

describe CouponsController do

  describe "Delete " do
    before(:each) do
      @coupon = Factory(:coupon)
      @company = Factory(:company)
      @coupon.company_id = @company.id
    end
    it "should delete correctly" do
      lambda do
      post :destroy, :id => @coupon.id
      end.should change(Coupon,:count).by(-1)
      #response.should redirect_to company_coupons_path(@company)
    end
  end
end
