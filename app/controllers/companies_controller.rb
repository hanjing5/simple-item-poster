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

end
