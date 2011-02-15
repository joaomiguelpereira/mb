class BusinessAdminsController < UsersController
  
  def new
    @user = BusinessAdmin.new
    render "users/new"
  end
  
  def create
    @user = BusinessAdmin.new(params[:business_admin])
    
    if @user.save
      flash_success "flash.success.user.create", {:keep=>true}
      redirect_to new_session_path(:email=>@user.email)
    else
      flash_error "flash.error.user.create"
      render "users/new"
    end
  end
end
