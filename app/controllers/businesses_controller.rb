class BusinessesController < BusinessAdminResourcesBaseController
  
  before_filter :ensure_authenticated, :ensure_is_business_admin
  before_filter  :ensure_has_access?, :except=>[:index]
  
  
  def index
    #@businesses = BusinessAdmin.find(params[:business_admin_id]).businesses
    @businesses = @current_user.businesses
  end
  
  ##################################
  ####Destroy
  ##################################
  def destroy
    @business=Business.find(params[:id])
    #has_access?(@business)
    
    #raise WebAppException::AuthorizationError if @business.business_admin_id != @current_user.id
    if @business.destroy
      flash_success "flash.success.business.destroy", {:keep=>true}
      redirect_to business_dashboard_path
    else
      flash_success "flash.error.business.destroy", {:keep=>true}
      redirect_to business_path(@business)
    end
    
  end
  ###################################
  ####Edit
  ##################################
  def edit
    @business=Business.find(params[:id])
    #has_access?(@business)
    
    #raise WebAppException::AuthorizationError if @business.business_admin_id != @current_user.id
  end
  
  def update
    @business=Business.find(params[:id])
    #has_access?(@business)
    
    #raise WebAppException::AuthorizationError if @business.business_admin_id != @current_user.id
    if @business.update_attributes(params[:business])
      respond_to do |format| 
        format.html {
          
          flash_success "flash.success.business.update", {:keep=>true}
          redirect_to business_admin_business_path(@current_user, @business)
        }
        format.js {
          flash_success "flash.success.business.update"
          render :show
        }
        
      end
      
    else
      flash_error "flash.error.business.update"
      render :edit
      
    end
    
  end
  
  ##############################################
  ###Show 
  ##############################################
  def show
    #find by name
    @business = Business.find(params[:id])
    #has_access?(@business)
    
    
  end
  ###############################################
  ######NEW
  ###############################################
  def new
    @business = Business.new
  end
  def create
    
    @business = Business.new(params[:business])
    @business.business_admin_id = @current_user.id
    if @business.save
      flash_success "flash.success.business.create", {:keep=>true}
      redirect_to business_dashboard_path
    else
      flash_error "flash.error.business.create"
      render :new
    end
    
  end
  
  
end
