class CompaniesController < ApplicationController
  before_filter :authorize_current_company

  def show
    
	@toolbar_hash = {:company => 'active'}
	@company = current_company
	@products_count = @company.products.count
    
    if @products_count == 0
      # if you dont have a product, we want to add a product before 
      # accessing your stats
	redirect_to first_product_company_products_path(current_company.id)
	return
    end

    @correct_company = false
    if company_signed_in?
      @correct_company = @company.id == current_company.id
    end
    @products = @company.products.paginate( :page => params[:product_page], :per_page => 5 )
  end

  def new
    @toolbar_hash = {:company => 'active'}
  	@company = Company.new
  end

  def create
      @company = Company.new(params[:company])
      if @company.save
        redirect_to companys_path
      else
        render 'companies/new'
      end

  end

  def index
    @toolbar_hash = {:company => 'active'}
    @toolbar_hash_company = 'active'
  	@companies = Company.order("name DESC")
  end

	def account
		@company = current_company
	end
	
	def update_password
		@company = Company.find(current_company.id)
		#if @company.password != params[:companies][:password_confirmation]
		#	flash[:error] = 'Old password didnt match. Please check again.'
		#	redirect_to account_companies_path
		#	return
		#end
		if @company.update_attributes(params[:companies])
			sign_in @company, :bypass=>true
			flash[:success] = 'Success! Password changed!'
			redirect_to account_companies_path
		else
			flash[:error] = 'Something went wrong. Please try again.'
			redirect_to account_companies_path
		end
	end

end
