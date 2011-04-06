class SessionsController < ApplicationController
  
  def new
  end
  
  def destroy
    reset_session
    session[:user_id] = nil
    cookies.delete :remember_me
    flash_success "flash.success.session.destroy", {:keep=>true}
    redirect_to root_path
    
  end
  
  def create
    
    email = params[:session][:email]
    
    password = params[:session][:password]
    keep_logged = params[:session][:keep_logged]
    #cases when the user haven't activated his/her account yet, just provide more useful information
    user = User.find_by_email(email)
    
    if (!user.nil? && !user.active) 
      flash_error "flash.error.session.inactive_user",{}, {:email=>user.email}  
      render :new
    else
      #Fall back
      
      user = User::authenticate(email, password)
      if user.nil?
        
        flash_error "flash.error.session.invalid_data"
        render :new
        
      else
        create_session_for(user,keep_logged)
        flash_success "flash.success.session.create", {:keep=>true}, {:email=>user.email}
        redirect_to root_path and return if( user.user? || user.staffer?)
        redirect_to business_dashboard_path(user.business_account) and return if user.business_admin?
      end
    end
  end
  private
  
  def create_session_for(user, keeploged)
    reset_session
    session[:user_id] = user.id
    
    if keeploged=="1"  
      cookies.permanent.signed[:remember_me] = [user.id, user.password_salt]
    end
  end
  
  
end
