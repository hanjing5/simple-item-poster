# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def create
		if(params[:company])
			@company = Company.new(params[:company])
			puts "Enter RegistrationController" 

			if @company.save
				sign_in @company
				respond_to do |format|
				format.js { render(:update) { |page| page.redirect_to @company } }
				end
				else
				flash[:error] = 'Registration failed. Please try again.'
					respond_to do |format|
					format.js
				end
				end

		elsif params[:publisher] 
			
			@publisher = Publisher.new(params[:publisher])

			if @publisher.save
				sign_in @publisher
				respond_to do |format|
					format.js { render(:update) { |page| page.redirect_to @publisher } }
				end
			else
				flash[:error] = 'Registration failed. Please try again.'
				respond_to do |format|
					format.html { redirect_to root_path }
					format.js
				end
			end
		elsif params[:user] 
			@product_id = params[:product_id]
			puts "My product_id #{@product_id}"
			@user = User.new(params[:user])
			puts "Enter RegistrationController" 

			if @user.save
				sign_in @user
				respond_to do |format|
					format.html { redirect_to :action=>'confirm_purchase', :controller=>'products', :user_id =>@user.id, :product_id =>params[:product_id] }
				end
			else
				flash[:error] = 'Registration failed. Please try again.'
				respond_to do |format|
					format.html { redirect_to product_user_prompt_path, :product_id=>params[:product_id]}
					format.js
				end
			end
    end
		#redirect_to :action=>'confirm_purchase', :controller=>'products', :user_id =>current_user.id, :product_id =>params[:product_id]
  end


end
