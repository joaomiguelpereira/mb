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
  
  def reset_password   
    if request.post?
      email = params[:reset_password][:email]
      raise NilOrEmptyEmailError if email.nil? || email.empty?
      user = User.find_by_email(email)
      raise EmailNotFoundError if user.nil?
      raise UserNotActiveError if !user.active
      user.reset_password_key = StringUtils::generate_random_string
      user.save!
      #send the email
      UserMailer.reset_password_mail(user).deliver   
      flash_success "flash.success.user.reset_password", {:keep=>true}, {:email=>user.email}
      redirect_to root_path
    else #if get
      render :reset_password
    end
  rescue UserNotActiveError
    flash_error "flash.error.user.reset_password_inactive_user", {}, {:email=>email}
    render :reset_password
  rescue NilOrEmptyEmailError
    flash_error "flash.error.user.reset_password_empty_email"
    render :reset_password
    #just render the template in case of get
  rescue EmailNotFoundError
    flash_error "flash.error.user.reset_password_email_not_found", {}, {:email=>email}
    render :reset_password
  end
  
  def save_new_password
        flash_success "flash.success.user.create_new_password", {:keep=>true}
        redirect_to new_session_path
    
  end
  def create_new_password
    reset_key = params[:reset_password_key]
    raise InvalidParameterError if reset_key.nil?  || reset_key.empty?
    @user = User.find_by_reset_password_key(reset_key)
    
    raise InvalidParameterError if @user.nil?  
    if request.put?
      @user.updating_password = true
      @user.reset_password_key = nil
      if @user.update_attributes(params[:user])
        flash_success "flash.success.user.create_new_password", {:keep=>true}
        redirect_to new_session_path
      else
        flash_error "flash.error.user.create_new_password"
      end
      
    end
    #just render the page if a redirect did not occurs
    
  rescue InvalidParameterError
    flash_error "flash.error.general.invalid_operation", {:keep=>true}
    redirect_to root_path
  end
  
  ##EXCEPTIONS FOR THIS CONTROLLER
  private
  class InvalidParameterError < StandardError
    
  end
  class UserNotActiveError < StandardError
    
  end
  class NilOrEmptyEmailError  < StandardError
    
  end
  class EmailNotFoundError < StandardError
  end
  
end
