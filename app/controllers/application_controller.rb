class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout "default"
  def index
    @title = "hello, man"
  end
  
end
