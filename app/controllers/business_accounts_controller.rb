class BusinessAccountsController < BusinessAdminResourcesBaseController
  
  before_filter :ensure_authenticated, :ensure_is_business_admin
  
  def index
      @business_account = @current_user.business_account
  end
  
  def availability
    @business_account = @current_user.business_account
    @availability = @business_account.availability
   
    if request.put?
      json_data = params[:json_data]
      if Availability.is_json_valid?(json_data)
        @availability.json_data = json_data
        @availability.save
        render :json=> { :status => :ok}
        #flash_success("flash.success.business_account.availability.update")
      else
        render :json=> { :status => :error}
        #flash_error("flash.error.business_account.availability.update")
    end
    
      
      
    end
  end
  
  def specialities
    
  end
end
