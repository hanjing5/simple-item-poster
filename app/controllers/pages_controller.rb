class PagesController < ApplicationController
  def home
    @company = Company.new
    @home = true

		if current_company
			redirect_to company_root_path
		end
    
  end

  def index
		if current_company
			redirect_to company_root_path
		end
  end

  def misc

  end

  def about
  end

  def contact
  end

  def documentation
  end

	def products
		if not current_company.admin?
			redirect_to root_path
		end
		@products = Product.all
	end

	def users
		if not current_company.admin?
			redirect_to root_path
		end
		@companies = Company.all
	end
end
