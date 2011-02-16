class StaffersController < BusinessAdminResourcesBaseController
  before_filter :ensure_authenticated, :ensure_is_business_admin, :ensure_has_access?
  
  
  ########################################
  ####List all staffers
  #########################################
  def index 
    @staffers = BusinessAdmin.find(params[:business_admin_id]).staffers
  end
  
  ###########################################
  #####Create staffer
  ############################################
  def new
    @staffer = Staffer.new
  end
  
  def create
    @staffer = Staffer.new(params[:staffer])
    @staffer.business_admin_id = params[:business_admin_id]
    #has to create a default password
    @staffer.password = StringUtils.generate_random_string(5)
    @staffer.need_new_password = true
    @staffer.notify_on_create = @staffer.notify_on_create=='1' ? true : false
    
    if @staffer.save
      flash_success "flash.success.staffer.create", {:keep=>true}
      redirect_to business_admin_staffers_path(params[:business_admin_id])
    else
      flash_error "flash.error.staffer.create"
      render :new
    end
    
  end
  
end
