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
    user = User::authenticate(email, password)
    if user.nil?
      flash_error "flash.error.session.invalid_data"
      render :new
    end
  end
end
