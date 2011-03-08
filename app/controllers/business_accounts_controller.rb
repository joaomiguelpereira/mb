class BusinessAccountsController < BusinessAdminResourcesBaseController
  
  before_filter :ensure_authenticated, :ensure_is_business_admin
  
  def index
      @business_account = @current_user.business_account
  end
  def availability
    
  end
  
  def specialities
    
  end
end
