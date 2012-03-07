xml.instruct!
xml.response do
	xml.company do
		xml.id @company.id
		xml.name @company.name
	end
	xml.coupon do
		xml.id @coupon.id
		xml.ext_id @coupon.ext_coupon_id
		xml.limit @coupon.limit
		xml.redeemed @coupon.redeemed
		xml.name @coupon.name
		xml.description @coupon.description
		xml.meta_data @coupon.meta_data 
		xml.picture_url @path + @coupon.picture_file_name
	end
end

