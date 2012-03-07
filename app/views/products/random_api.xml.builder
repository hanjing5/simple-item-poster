xml.instruct!
xml.response do
	xml.product do
		xml.id @product.id
		xml.ext_id @product.ext_product_id
		xml.name @product.name
		xml.description @product.description
		xml.meta_data @product.meta_data
		xml.price @product.price
		xml.picture_path @path + @product.picture_file_name
	end
end

