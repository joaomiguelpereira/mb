class BusinessAccounts::AdminsController < BusinessAdminResourcesBaseController
  
  before_filter :ensure_authenticated,  :ensure_has_access?, :ensure_is_business_admin


  def index
    @admins = BusinessAccounts.find(params[:business_account_id]).business_admins
  end
  
  
  ###########################################
  #####Create staffer
  ############################################
  def new
    @admin = BusinessAdmin.new
  end

  
  def create
    @admin = BusinessAdmin.new(params[:admin])
    @admin.business_account_id = params[:business_account_id]
    #has to create a default password
    @admin.password = StringUtils.generate_random_string(5)
    @admin.need_new_password = true
    @admin.created_by = @current_user.id
    
    if @admin.notify_on_create.is_a?(String)
      @admin.notify_on_create = @admin.notify_on_create=='1' ? true : false  
    end
    
    
    if @admin.save
      flash_success "flash.success.admin.create", {:keep=>true}
      redirect_to business_account_admins_path(params[:business_account_id])
    else
      flash_error "flash.error.admin.create"
      render :new
    end
    
  end

end
