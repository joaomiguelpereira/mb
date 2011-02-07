class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  before_filter :mailer_set_url_options
  
  layout "default"
  def index
    @title = "hello, man"
  end
  
  
  protected
  def flash_error(i18nkey) 
    flash.now[:error] = I18n.t(i18nkey) 
  end
  
  private 
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
