class PasswordsController < ApplicationController
	def account
		@company = current_company
	end
	
	def update
		@company = Company.find(current_company.id)
		#if @company.password != params[:companies][:password_confirmation]
		#	flash[:error] = 'Old password didnt match. Please check again.'
		#	redirect_to account_companies_path
		#	return
		#end
		if @company.update_attributes(params[:company])
			sign_in @company, :bypass=>true
			flash[:success] = 'Success! Password changed!'
			redirect_to account_companies_path
		else
			flash[:error] = 'Something went wrong. Please try again.'
			redirect_to account_companies_path
		end
	end
end
