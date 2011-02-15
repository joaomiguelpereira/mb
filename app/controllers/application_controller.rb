class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  
  #helper_method :current_user
  before_filter :set_current_user, :auto_login
  
  layout "default"
  def index
    @title = "hello, man"
  end
  
  
  protected
  def ensure_authenticated
    raise WebAppException::SessionRequiredError if @current_user.nil?
  end
  
  def ensure_is_business_admin
    raise WebAppException::AuthorizationError if !@current_user.business_admin?
  end
  
  
  def flash_error(i18nkey, options={},*params)
    if options[:keep] 
      flash[:error] = I18n.t(i18nkey,*params)
    else
      flash.now[:error] = I18n.t(i18nkey,*params)
    end
    
    
  end
  def flash_success(i18nkey, options={},*params) 
    if options[:keep] 
      flash[:success] = I18n.t(i18nkey,*params)
    else
      flash.now[:success] = I18n.t(i18nkey,*params)
    end 
  end
  
  private
  
  def auto_login
     
    if  cookies.signed[:remember_me] && @current_user.nil?
      user = User.authenticate_from_salt(*cookies.signed[:remember_me])
      if !user.nil?
        session[:user_id] = user.id
        @current_user = user
      else
        cookies.delete :remember_me       
      end  
    end
  end
  
  
  def set_current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
