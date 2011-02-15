class StaffersController < BusinessAdminResourcesBaseController
  before_filter :ensure_authenticated, :ensure_is_business_admin, :ensure_has_access?
  
  
  def index 
    @staffers = BusinessAdmin.find(params[:business_admin_id]).staffers
  end
  
  def new
    @staffer = Staffer.new
  end
  
  
end
