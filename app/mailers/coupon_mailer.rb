class CouponMailer < ActionMailer::Base
  default :from => "notifications@gamertiser.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end

  def coupon_email(user, coupon)
    @user = user
	@coupon = coupon
    mail(:to => user.email, :subject => "Reward for being an awesome gamer!")
  end
end
