class CustomFailure < Devise::FailureApp
	# registration failure
  def redirect_url
		if params[:user]
			puts "custom_failure.rb"
			flash[:sign_in_error] = "Wrong username or password. Please Try Again"
    	return product_user_prompt_path
		end

		if params[:company]
			puts "Email custom_failure.rb"
			flash[:error] = "Wrong email or password. Please Try Again"
    	return redirect_to :action=>'create', :controller=>'registrations', :company=>params[:company]
		end
		return root_url
  end

  def respond
    if http_auth?
      http_auth
    else
			puts 'respond'
			puts 'redirecting to registrations controller for company'
			#redirect
			super
    	#redirect_to :action=>'create', :controller=>'registrations', :company=>params[:company]
      #redirect company_path
    end
  end

	
end
