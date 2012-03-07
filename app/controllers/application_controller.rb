class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include UsersHelper

  def login
    @user = api_find_or_create_user(params[:user])
    unless @user.nil?
      sign_in @user
    end
  end

  def authorize_current_user
    #fill with authentication


  end
  def authorize_current_company
    #fill with authentication
  end

	# TODO:This breaks redirects for publisher and companies also
	# delete or find new solution
	
  def after_sign_out_path_for(resources)
		if current_user
			return api_v1_product_inventory_display_path
		end
		if current_company
			return root_path
		end

		if current_publisher
			return root_path
		end
		# this should actually be a 404 path or something
		root_path
  end

#	def after_sign_in_path_for(resource)
#		if current_publisher
#			return publisher_root_path
#		end
#		if current_company
#			return company_root_path
#		end

#		if not user_signed_in?
#			puts 'user is not signed in'
#		end
#		if current_user
#		puts "after_sign_in_path_for"
#		puts session
#		puts params
#		puts "session with user return to"
#		puts session[:"user.return_to"]
#			@product_id = params[:product_id]
		# if there is no session go to users/new
		# else to to what ever the session return url is
		
    #(session[:"user.return_to"].nil?) ? api_v1_product_inventory_display_path : session[:"user.return_to"].to_s
#			if params[:product_id]
#				render api_v1_product_confirm_purchase_path, :product_id=>params[:product_id]
#			else
#				api_v1_product_inventory_display_path
#			end
#		end
#	end
	#def after_sign_in_path_for(resources)
	#	if current_user
	#		puts "params #{params}"
	#		return api_v1_product_confirm_purchase_path
	#	end
	#	root_path
	#end	
	
  private

end
