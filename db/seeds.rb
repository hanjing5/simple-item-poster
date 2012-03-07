# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Test use

###############################################
# This creates and populates the type model with
# some based types of products
###############################################
Type.delete_all
State.delete_all

Type.create(:name => "food")
Type.create(:name => "electronic")
Type.create(:name => "toy")

state_list =['AL','MT','AK','NE','AZ','NV','AR','NH','CA','NJ','CO','NM','CT','NY','DE','NC','FL','ND','GA','OH','HI','OK','ID','OR','IL','PA','IN','RI','IA','SC','KS','SD','KY','TN','LA','TX','ME','UT','MD','VT','MA','VA','MI','WA','MN','WV','MS','WI','MO','WY']

state_list.each do |s|
	State.create(:state => s)
end
puts 'States created for shipping addresses'

def inform(obj)
	if obj.save
		puts "Type: " + obj.to_s
		puts "Name: " + obj.name
		puts "Password: " + obj.password
		puts "Successfully created!"
		puts
	else
		puts "Something's went wrong!"
		puts obj.errors
		puts
	end
end
###################################################

###################################################
# This generates 3 test accounts for sample/testing
###################################################
c = Company.new( :name => "coke", :email => "coke@coke.coke", :password => "coke12", :password_confirmation => "coke12" )
a = User.new( :name => "lolcat", :email => "lolcat@lolcat.lolcat", :password => "lolcat", :password_confirmation => "lolcat" )
p = Publisher.new( :name => "blizzard", :email => "blizzard@blizzard.blizzard", :password => "blizzard", :password_confirmation => "blizzard" )

# list of objects you want to seed
object_list = [c, a, p]

# seed and inform
object_list.each { |obj| inform(obj)}
###################################################


###################################################
# this simulates first game 's redemptions
# between start of first game's create and today, 
# create between 1 - 10 redemptions per day
# NOTE: Set :attr_accessible for :created_at in 
# app/model/game_earnings.rb or the created at simulation
# WOULDN'T work
###################################################
def seed_redemptions
g = Game.first
end_date = DateTime.now
#start_date = g.created_at
start_date = DateTime.now - 60.days
while start_date < end_date
	start_date = start_date + 1.days
	r = rand(10)
	puts "#{r} coupons/rewards on #{start_date}"
	while r > 0
		@ge = GameEarnings.new(
			:game_id => 1, 
			:coupon_id => 1, 
			:earnings => 0.75, 
			:coupon_cost => 0.75,
			:user_id => 1,
			:created_at => start_date
		)
		@ge.save
		r -= 1
	end
end
end
#seed_redemptions
##################################################

###################################################
# this simulates first coupon 's impressions and
# click_throughs
# between start of first coupon's create and today, 
# create between 1 - 100 impressions per day
# create between 0 - max(impressions) per day
# NOTE: Set :attr_accessible for :created_at in 
# app/model/coupon_stat.rb or the created at simulation
# WOULDN'T work
###################################################
def seed_impressions(max)
	g = Coupon.first
	end_date = DateTime.now
	start_date = DateTime.now - 60.days

	while start_date < end_date
		start_date = start_date + 1.days
		r = rand(max)
		m = r
		puts "#{r} coupons/rewards impressions on #{start_date}"
		while r > 0
			@ge = g.coupon_stats.create(
				:game_id => 1, 
				:impression => 1,
				:created_at => start_date
			)
			@ge.save
			r -= 1
		end
		x = rand(m)
		puts "#{x} coupons/rewards click_through on #{start_date}"
		while x > 0
			@ge = g.coupon_stats.create(
				:game_id => 1, 
				:click_through => 1,
				:created_at => start_date
			)
			@ge.save
			x -= 1
		end
	end
end

#seed_impressions(20)
##################################################

#c.ads.create
#c.ads.create
#c.ads.create
#c.coupons.create
#c.coupons.create
#c.coupons.create



