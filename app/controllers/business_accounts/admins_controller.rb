class BusinessAccounts::AdminsController < BusinessAdminResourcesBaseController
  
  #before_filter :ensure_authenticated,  :ensure_has_access?, :ensure_is_business_admin


  def index
    @admins = BusinessAccount.find(params[:business_account_id]).business_admins
  end
  
  def show
    @admin = BusinessAdmin.find(params[:id])
  end
  ###########################################
  #####Create staffer
  ############################################
  def new
    @admin = BusinessAdmin.new
  end

  
  def create
    @admin = BusinessAdmin.new(params[:business_admin])
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
  
  ##########################################
  ###Send activation email on rquestet
  ##########################################
  def send_activation_email
    @admin = BusinessAdmin.find(params[:id])
    if @admin.active
      flash_error "flash.error.admin.send_activation_mail_active" 
    else 
      UserMailer.admin_activation_email(@admin).deliver
      flash_success "flash.success.admin.send_activation_mail",{}, {:email=>@admin.email} 
    end
    
  end
  
  ###########################################
  ####Destroy
  ##########################################
  def destroy
    @admin = BusinessAdmin.find(params[:id])
    if @admin.id == @current_user.id
      flash_error "flash.error.admin.destroy", {:keep=>true}
      redirect_to business_account_admin_path(@current_user.business_account, @admin)
    elsif @admin.destroy
      flash_success "flash.success.admin.destroy", {:keep=>true}
      redirect_to business_account_admins_path(@current_user.business_account)
    else
      flash_error "flash.error.admin.destroy", {:keep=>true}
      redirect_to business_account_admin_path(@current_user.business_account, @admin)
    end
  end
  
  ##############################################
  ######Modify
  ##############################################
  def edit
    @admin = BusinessAdmin.find(params[:id])
  end
  
  def update
   
    @admin = BusinessAdmin.find(params[:id])
    if @admin.update_attributes(params[:business_admin])
      
      respond_to do |format|
        format.html {
          flash_success "flash.success.admin.update", {:keep=>true}
          redirect_to business_admin_admin(@current_user.business_admin, @admin)
        }
        format.js { flash_success "flash.success.admin.update"
          render :show
        }
      end
    else
      flash_error "flash.error.admin.update"
      render :edit
    end
  end

end
