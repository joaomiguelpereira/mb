class BusinessesController < ApplicationController
  
  before_filter :ensure_authenticated, :ensure_is_business_owner
  
  def index
    @businesses = @current_user.businesses
  end
  
  def new
    @business = Business.new
  end
  
  def create
    
    @business = Business.new(params[:business])
    @business.user_id = @current_user.id
    if @business.save
      flash_success "flash.success.business.create", {:keep=>true}
      redirect_to business_dashboard_path
    else
      flash_error "flash.error.business.create"
      render :new
    end
    
  end
end
