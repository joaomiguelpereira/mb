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
    
    #Get records as JSON
    if request.get? && request.format.json?  
      render :json=>@specialities.to_json
    end
    
    #Save new record as JSON
    if request.post? && request.format.json?
      specR = Speciality.new(ActiveSupport::JSON.decode(params[:speciality]))
      #try to find if
      speciality = Speciality.find_by_name(specR.name)
      
      
      if speciality && @business_account.specialities.exists?(speciality) 
        render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.create.exists")}
      else
        speciality = specR if speciality.nil?   
        @business_account.specialities << speciality
        if @business_account.save
          render :json=> { :status => :ok, :message=>I18n.t("flash.success.speciality.create")}
        else 
          render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.create")}
        end
      end
    end
    #Delete record
    if request.delete?
      speciality = Speciality.find(params[:speciality_id])
      @business_account.specialities.delete(speciality)
      render :json=> { :status => :ok, :message=>I18n.t("flash.success.speciality.delete")}
    end
  rescue ActiveRecord::UnknownAttributeError
    render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.general")}
  end
end
