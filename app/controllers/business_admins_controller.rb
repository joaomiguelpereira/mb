class BusinessAdminsController < UsersController
  
  def new
    @user = BusinessAdmin.new
    render "users/new"
  end
  
  def create
     
    @user = BusinessAdmin.new(params[:business_admin])    
    
    baccount = BusinessAccount.new
    @user.business_account = baccount    
    
    if @user.save
      baccount.owner = @user
      baccount.save
      flash_success "flash.success.user.create", {:keep=>true}
      flash_notice "flash.notice.user.activation_pending", {:keep=>true}, {:email=>@user.email}
      redirect_to new_session_path(:email=>@user.email)
    else
      flash_error "flash.error.user.create"
      render "users/new"
    end
  end
end
