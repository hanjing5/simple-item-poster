class CompaniesController < ApplicationController
  before_filter :authorize_current_company

  def show
    
	@toolbar_hash = {:company => 'active'}
	@company = current_company
	@products_count = @company.products.count
	@products_earnings = 0
	@company.invoices.each do |i|
		@products_earnings += i.price
	end
	@products_view = 0
	@company.products.each do |p|
		@products_view += p.displayed
	end
    
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

	###########################################################
	# Edit is the controller for the landing page of a user
	# who clicked on a link
	###########################################################
	def edit
		@company = current_company
	end

	###########################################################
	# Update is the controller for a user updating the link/
	# product he/she is trying to sell
	###########################################################
	def update
		@company = current_company
			if @company.update_attributes(params[:company])
				flash[:success]="Update Success!"
				redirect_to account_companies_path
			else
				flash[:error]="Failed to updated!"
				redirect_to account_companies_path
			end
	end

	def edit_password
		@header_edit_password = 'active'
	end

	def bank
		@header_bank = 'active'
	end


	def account
		redirect_to bank_companies_path
	end

end
