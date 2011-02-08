class SessionsController < ApplicationController
  
  def new
    
    @email = params[:email] if params[:email]
    if @email 
      user = User.find_by_email(@email)
      if user && !user.active
        @not_active = true
      end
    end
    
    
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
        flash_success "flash.success.session.create", {:email=>user.email}
        redirect_to root_path
      end
    end
    
    
  end
  private
  def create_session_for(user, keeploged)
    reset_session
    session[:user_id] = user.id
  end
end
