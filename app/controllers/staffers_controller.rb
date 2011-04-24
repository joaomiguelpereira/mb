class StaffersController < UsersController
	########################################
	### dashboard
	#######################################
	def dashboard
		@staffer = Staffer.find(params[:id])
	end

	def availability_exceptions

		@staffer = Staffer.find(params[:id])
		@availability = @staffer.availability
		json_data = params[:json_data]
		if Availability.is_exceptions_json_valid?(json_data)
			@availability.exceptions_json_data = json_data
			@availability.save
			render :json=> { :status => :ok, :message=>I18n.t("flash.success.business_account.availability_exceptions.update")}
		else
			render :json=> { :status => :error, :message=>I18n.t("flash.error.business_account.availability_exceptions.update")}

		end

	end
	##TODO: Refactor this since the logic is copy/paste from business_accounts_controller
	def specialities
	@staffer = Staffer.find(params[:id])
    @specialities = @staffer.specialities
    
    #Get records as JSON
    if request.get? && request.format.json?  
      render :json=>@specialities.to_json
    end
    
    #Save new record as JSON
    if request.post? && request.format.json?
      specR = Speciality.new(ActiveSupport::JSON.decode(params[:speciality]))
      #try to find if
      speciality = Speciality.find_by_name(specR.name)
      
      
      if speciality && @staffer.specialities.exists?(speciality) 
        render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.create.exists")}
      else
        speciality = specR if speciality.nil?   
        @staffer.specialities << speciality
        if @staffer.save
          render :json=> {:speciality=>speciality.to_json, :status => :ok, :message=>I18n.t("flash.success.speciality.create")}
        else 
          render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.create")}
        end
      end
    end
    #Delete record
    if request.delete?
      speciality = Speciality.find(params[:speciality_id])
      @staffer.specialities.delete(speciality)
      render :json=> { :status => :ok, :message=>I18n.t("flash.success.speciality.delete")}
    end
  rescue ActiveRecord::UnknownAttributeError
    render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.general")}
  rescue ActiveRecord::RecordInvalid
  	render :json=> { :status => :error, :message=>I18n.t("flash.error.speciality.validation")}
  
  end
  
  
	##TODO: Refactor this since teh logic is copy/paste from business_accounts
	def availability
		dateDaysNamesShort = I18n.t('date.abbr_day_names').dup
		dateDayNames = I18n.t('date.day_names').dup
		dateMonthNames = I18n.t('date.month_names').dup

		dateMonthNamesShort = I18n.t('date.abbr_month_names').dup

		dateMonthNames.delete_at(0)
		dateMonthNamesShort.delete_at(0)
		@js_i18n_data = {:dateDaysNames=>dateDayNames.to_s,:dateDaysNamesShort=>dateDaysNamesShort.to_s, :dateMonthNames=>dateMonthNames.to_s,  :dateMonthNamesShort=>dateMonthNamesShort.to_s}

		@staffer = Staffer.find(params[:id])
		@availability = @staffer.availability

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

end
