class SessionsController < Devise::SessionsController
	def create
			puts "attempts to create session in overriding method session"
			puts params
			puts "right before warden"
			puts "resource name: #{resource_name}"
			resource = warden.authenticate!(:scope => resource_name, 
									#:recall => "#{controller_path}#new")
									:recall => "registrations#create")
			set_flash_message(:notice, :signed_in) if is_navigational_format?
			puts "warden resource result: resource"
			#flash[:error] = "Wrong username or password. Please Try Again"
				#puts "There is a product id"
				#return api_v1_product_confirm_purchase(:product_id=>params[:product_id])
			if sign_in(resource_name, resource)
				puts 'we have successfully signed in'
				
				#respond_with resource, :location => after_sign_in_path_for(resource)
				respond_to do |format|
					format.html {redirect_to root_path}
				end
			else
				respond_to do |format|
				puts 'we failed to sign in'
					format.html {redirect_to :action=>'create', :controller=>'registrations', :company=>params[:company]}
				end
			end	
	end
end
