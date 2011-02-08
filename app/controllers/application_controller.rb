class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  
  helper_method :current_user
  
  layout "default"
  def index
    @title = "hello, man"
  end
  
  
  protected
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
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
