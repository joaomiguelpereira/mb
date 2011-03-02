class BusinessAccounts::BusinessAccountAdminsController < BusinessAdminResourcesBaseController
  
  before_filter :ensure_authenticated,  :ensure_has_access?, :ensure_is_business_admin
  

end
