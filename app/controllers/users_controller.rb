class UsersController < ApplicationController
  
  def new
    #get the role from params
    @role = params[:role]
    #set the role to user if role is not set
    @role = User::USER unless @role
    @user = User.new
    @user.role = @role 
  end
  
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash_success "flash.success.user.create", {:keep=>true}
      redirect_to new_session_path(:email=>@user.email)
    else
      flash_error "flash.error.user.create"
      render :new
    end
    
  end
  
  def activate
    #find user by it's activation key
    user = nil
    user = User.find_by_activation_key(params[:activation_key]) if params[:activation_key]
    if user.nil?
      flash_error "flash.error.user.activate", {:keep=>true}
      redirect_to root_path
    else
      user.active = true
      user.activation_key = nil
      user.save!
      flash_success "flash.success.user.activate", {:keep=>true}, {:email=>user.email}
      redirect_to new_session_path
    end
    
  end
  
end
