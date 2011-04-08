class BusinessAccountsController < BusinessAdminResourcesBaseController
  
  #before_filter :ensure_authenticated, :ensure_is_business_admin, :ensure_has_access?
  
  def index
    @business_account = @current_user.business_account
  end
  
  def availability_exceptions
    
    @business_account = @current_user.business_account
    @availability = @business_account.availability
    json_data = params[:json_data]
    if Availability.is_exceptions_json_valid?(json_data)
      @availability.exceptions_json_data = json_data      
      @availability.save
      render :json=> { :status => :ok, :message=>I18n.t("flash.success.business_account.availability_exceptions.update")}
    else
      render :json=> { :status => :error, :message=>I18n.t("flash.error.business_account.availability_exceptions.update")}
      
    end
    
  end
  
  def availability
    
    
    dateDaysNamesShort = I18n.t('date.abbr_day_names').dup
    dateDayNames = I18n.t('date.day_names').dup
    dateMonthNames = I18n.t('date.month_names').dup
    
    dateMonthNamesShort = I18n.t('date.abbr_month_names').dup
    
    dateMonthNames.delete_at(0)
    dateMonthNamesShort.delete_at(0)
    @js_i18n_data = {:dateDaysNames=>dateDayNames.to_s,:dateDaysNamesShort=>dateDaysNamesShort.to_s, :dateMonthNames=>dateMonthNames.to_s,  :dateMonthNamesShort=>dateMonthNamesShort.to_s}
    
    @business_account = @current_user.business_account
    @availability = @business_account.availability
    
    
    if request.put?
      json_data = params[:json_data]
      if Availability.is_json_valid?(json_data)
        @availability.json_data = json_data
        @availability.save
        render :json=> { :status => :ok, :message=>I18n.t("flash.success.business_account.availability.update")}
        #flash_success("flash.success.business_account.availability.update")
      else
        render :json=> { :status => :error, :message=>I18n.t("flash.error.business_account.availability.update")}
        #flash_error(")
      end
      
      
      
    end
  end
  
  def specialities
    @business_account = @current_user.business_account
    @specialities = @business_account.specialities
    
    if request.get? && request.format.json?
      res = {:status=>"error", :message=>"Working"}
      render :json=>res.to_json
      
    end
  end
end
