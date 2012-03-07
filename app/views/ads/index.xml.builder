xml.instruct!
xml.response do
	xml.ads do
		@ads.each do |ad|
			xml.ad do
				xml.company_id ad.company.id
				xml.copany_name ad.company.name
				xml.id ad.id
				xml.title ad.name
				xml.description ad.description
				xml.created_at ad.created_at
				xml.updated_at ad.updated_at
				xml.limit ad.limit
				xml.type ad.type
				xml.cost_per_1k_views ad.cost_per_impression
				xml.cost_per_1k_clicks ad.cost_per_click
				xml.cost_per_1k_purchases ad.cost_per_purchase
				xml.love_hatred ad.love_hate
				xml.relief_fear ad.relief_fear
				xml.excitement_boredom ad.excite_bore
				xml.happy_sad ad.happy_sad
				xml.funny_serious ad.funny_serious
				xml.sexy_disgust ad.sexy_disgust
				xml.image ad.picture.url
			end
			
		end
	end
end
