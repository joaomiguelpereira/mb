class BusinessAdminResourcesBaseController < ApplicationController
  
  before_filter :ensure_authenticated, :ensure_is_business_admin, :ensure_has_access?

  private 
  def ensure_has_access?
    #allow also the staffer to access 
    raise WebAppException::AuthorizationError if params[:business_account_id].nil?
    business_account = BusinessAccount.find(params[:business_account_id])
    business_account.business_admins.each do |admin|
     return if admin.id.to_s == @current_user.id.to_s
    end    
    #raise WebAppException::AuthorizationError if business_account. != @current_user.id.to_s
    raise WebAppException::AuthorizationError
  end
end
