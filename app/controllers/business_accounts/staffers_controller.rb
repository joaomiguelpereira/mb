class BusinessAccounts::StaffersController < BusinessAdminResourcesBaseController
  #before_filter :ensure_authenticated,  :ensure_has_access?, :ensure_is_business_admin
   
  

  ########################################
  ####List all staffers
  #########################################
  def index 
    @staffers = BusinessAccount.find(params[:business_account_id]).staffers
  end
  
  def show
    @staffer = Staffer.find(params[:id])
  end
  ###########################################
  #####Create staffer
  ############################################
  def new
    @staffer = Staffer.new
  end
  
  def create
    @staffer = Staffer.new(params[:staffer])
    @staffer.business_account_id = params[:business_account_id]
    #has to create a default password
    @staffer.password = StringUtils.generate_random_string(5)
    @staffer.need_new_password = true
    
    if @staffer.notify_on_create.is_a?(String)
      @staffer.notify_on_create = @staffer.notify_on_create=='1' ? true : false  
    end
    
    
    if @staffer.save
      flash_success "flash.success.staffer.create", {:keep=>true}
      redirect_to business_account_staffers_path(params[:business_account_id])
    else
      flash_error "flash.error.staffer.create"
      render :new
    end
    
  end
  
  ##############################################
  ######Modify
  ##############################################
  def edit
    @staffer = Staffer.find(params[:id])
  end
  
  def update
   
    @staffer = Staffer.find(params[:id])
    if @staffer.update_attributes(params[:staffer])
      
      respond_to do |format|
        format.html {
          flash_success "flash.success.staffer.update", {:keep=>true}
          redirect_to business_admin_staffer(@staffer.business_admin, @staffer)
        }
        format.js { flash_success "flash.success.staffer.update"
          render :show
        }
      end
    else
      flash_error "flash.error.staffer.update"
      render :edit
    end
  end
  
  ##########################################
  ###Send activation email on rquestet
  ##########################################
  def send_activation_email
    @staffer = Staffer.find(params[:id])
    if @staffer.active
      flash_error "flash.error.staffer.send_activation_mail_active" 
    else 
      UserMailer.staffer_activation_email(@staffer).deliver
      flash_success "flash.success.staffer.send_activation_mail",{}, {:email=>@staffer.email} 
    end
    
  end

  ###########################################
  ####Destroy
  ##########################################
  def destroy
    @staffer = Staffer.find(params[:id])
    if @staffer.destroy
      flash_success "flash.success.staffer.destroy", {:keep=>true}
      redirect_to business_account_staffers_path(@current_user.business_account)
    else
      flash_error "flash.error.staffer.destroy", {:keep=>true}
      redirect_to business_account_staffes_path(@current_user.business_account, @staffer)
    end
  end
end
