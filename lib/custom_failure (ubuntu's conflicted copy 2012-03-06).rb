class CustomFailure < Devise::FailureApp
	# registration failure
  def redirect_url
		if params[:user]
			puts "custom_failure.rb"
			flash[:sign_in_error] = "Wrong username or password. Please Try Again"
    	return product_user_prompt_path
		end
		return root_url
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

	
end
