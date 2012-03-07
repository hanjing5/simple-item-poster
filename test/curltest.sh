# user log in
#curl http://0.0.0.0:3000/api/v1/users -d email=lolcat@lolcat.lolcat -d password=lolcat -d game_token=12345
#curl http://0.0.0.0:3000/api/v1/users -d email=lolcat@lolcat.lolcat -d password=lolcat -d game_token=''
#curl http://0.0.0.0:3000/api/v1/users -d email=lolcat@lolcat.lolcat -d password='' -d game_token=12345
#curl http://0.0.0.0:3000/api/v1/users -d email=lolcat@lolcat.lolcat -d password=lolcat -d game_token=12345

# user create
#curl http://0.0.0.0:3000/api/v1/users/create -d email=jack@gmail.com.com -d password=jack12 -d game_token=12345

#curl http://0.0.0.0:3000/api/v1/users/create -d email=lolcat@lolcat.lolcat -d password=lolcat -d game_token=12345
#curl http://0.0.0.0:3000/api/v1/users/create -d email=lolcat@lolcat.lolcat -d password=lolcat
#curl http://0.0.0.0:3000/api/v1/users/create -d email=lolcat@lolcat.lolcat -d game_token=12345
#curl http://0.0.0.0:3000/api/v1/users/create -d password=lolcat -d game_token=12345

# Coupon Show (Get)
#curl http://0.0.0.0:3000/api/v1/coupon.json -d token=12345

#curl http://0.0.0.0:3000/api/v1/coupon.json -d token=skladjfklajf
#curl http://0.0.0.0:3000/api/v1/coupon.json

# Coupon Increment Click Through (PUT)
# TODO: this does quite work
#curl http://0.0.0.0:3000/api/v1/coupon.json --request PUT --data "token=12345"

# Coupon Redeem (POST)
curl http://0.0.0.0:3000/api/v1/coupon/redeem.json -d token=12345 -d email=hanqijing@gmail.com -d coupon_id=1

#curl http://0.0.0.0:3000/api/v1/coupon/redeem.json -d token=aefe2fwaf -d email=hanqijing@gmail.com -d coupon_id=0123
#curl http://0.0.0.0:3000/api/v1/coupon/redeem.json -d token=12345 -d email=hanqaefef -d coupon_id=1
#curl http://0.0.0.0:3000/api/v1/coupon/redeem.json

