class PicsController < ApplicationController
  def new
	@pic = Pic.new
  end

  def edit
  end

  def create
	@pic = Pic.new(params[:pic])
	
	if @pic.save 
		flash[:success] = "Sign Up Success!"
		redirect_to '/pics/show'
	else 
		render 'new'
	end

  end
  def index
  end

  def show
	@pics = Pic.all
  end
end
