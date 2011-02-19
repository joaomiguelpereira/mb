class BusinessAdminResourcesBaseController < ApplicationController
  

  private 
  def ensure_has_access?
    #allow also the staffer to access 
    
    raise WebAppException::AuthorizationError if params[:business_admin_id].to_s != @current_user.id.to_s
    #raise WebAppException::AuthorizationError if business.business_admin_id != @current_user.id
  end
end
