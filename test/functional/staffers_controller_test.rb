require 'test_helper'

class StaffersControllerTest < ActionController::TestCase

	setup do
		@badmin = Factory.create(:business_admin)
		@baccount = Factory.create(:business_account, :owner=>@badmin)
		@badmin.business_account = @baccount
		@badmin.save
		@staffer = Factory.create(:staffer, :business_account=>@baccount)
		@otherStaffer = Factory.create(:staffer, :business_account=>@baccount)
	end

	########################################
	#### Test show dashboard
	########################################
	test "should not show staffer dashboard for not authenticated user" do
		staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
		assert_raise( WebAppException::SessionRequiredError) do
			get :dashboard, {:id=>staffer.id}, {}
		end
	end

	test "should not show staffer dashboard for not correct authenticated user" do
		staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
		fake = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
		assert_raise( WebAppException::AuthorizationError) do
			get :dashboard, {:id=>staffer.id}, authenticated_user(fake)
		end

	end

	test "should  show staffer dashboard for  correct authenticated user" do
		staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)

		get :dashboard, {:id=>staffer.id}, authenticated_user(staffer)
		assert_template :dashboard
		assert_not_nil assigns(:staffer)

	end

	#Test availabilities
	###TODO: Refactor everything related to availabilities, since the logic for staffers is the same for the business_accounts

	####################Availability exception

	test "update availability exception" do
		json_data = Array.new
		#create two new exceptions
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_success("flash.success.business_account.availability_exceptions.update");
	end

	test "update availability more exception" do
		json_data = Array.new
		#create two new exceptions
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}

		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_success("flash.success.business_account.availability_exceptions.update");
	end

	test "update availability exception if dates same" do
		json_data = Array.new
		#create two new exceptions
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_success("flash.success.business_account.availability_exceptions.update");
	end

	test "update empty availability exception" do
		json_data = Array.new
		#create two new exceptions
		#json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_success("flash.success.business_account.availability_exceptions.update");
	end

	test "dont update nil availability exception" do
		json_data = ""
		#create two new exceptions
		#json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_error("flash.error.business_account.availability_exceptions.update");
	end

	test "dont update not valid availability exception" do
		json_data = Array.new
		#create two new exceptions
		json_data << {"start_date"=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_error("flash.error.business_account.availability_exceptions.update")
	end

	test "do not update availability exception if dates wrong" do
		json_data = Array.new
		#create two new exceptions
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"11/12/2001", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_error("flash.error.business_account.availability_exceptions.update")
	end

	test "do not update availability exception if dates wrong format" do
		json_data = Array.new
		#create two new exceptions
		json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"232323", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"11111", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
		put :availability_exceptions, {:id=>@staffer.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
		assert_json_error("flash.error.business_account.availability_exceptions.update")
	end

	####################Availability
	test "update availability" do
		json_data_array = Array.new
		for i in (0..(Availability::WEEK_DAYS-1))
			day_array = Array.new
			day_array << {Availability::START_HOUR_FIELD_NAME=>30, Availability::END_HOUR_FIELD_NAME=>120, Availability::WEEK_DAY_FIELD_NAME=>i}

			day_array << {Availability::START_HOUR_FIELD_NAME=>150, Availability::END_HOUR_FIELD_NAME=>210, Availability::WEEK_DAY_FIELD_NAME=>i}

			json_data_array << day_array
		end
		put :availability, {:id=>@staffer.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
		#json = ActiveSupport::JSON.decode(@response.body)
		#assert_equal json["message"], I18n.t("flash.success.business_account.availability.update")

		assert_json_success("flash.success.business_account.availability.update");
	end

	test "dont update availability with invalid format" do
		json_data_array = Array.new
		for i in (0..1)
			day_array = Array.new
			day_array << {Availability::START_HOUR_FIELD_NAME=>30, Availability::END_HOUR_FIELD_NAME=>120, Availability::WEEK_DAY_FIELD_NAME=>i}

			day_array << {Availability::START_HOUR_FIELD_NAME=>150, Availability::END_HOUR_FIELD_NAME=>210, Availability::WEEK_DAY_FIELD_NAME=>i}
			day_array  << {:weid=>19}

			json_data_array << day_array
		end

		put :availability, {:id=>@staffer.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
		assert_json_error("flash.error.business_account.availability.update");
	end

	test "get availability" do
		get :availability, {:id=>@staffer.id}, authenticated_user(@badmin)
		assert_not_nil assigns(:availability)
	end

###End testing availabilities


##Test specialities
##TODO: Recfactory this since is repeated with logic in business_accounts

  test "dont get specialities if not authenticated" do 
     assert_raise(WebAppException::SessionRequiredError) do
      get :specialities,{:id=>@staffer.id},{}
    end
  end
  
  test "dont get specialities for other user" do  
    assert_raise(WebAppException::AuthorizationError) do
      get :specialities,{:id=>@staffer.id},authenticated_user(@otherStaffer)
    end
  end
  
  test "get specialities" do
    get :specialities,{:id=>@staffer.id},authenticated_user(@badmin)
    assert_not_nil assigns(:staffer)
    assert assigns(:specialities)  
  end
  
  test "get json specialities" do
    #create some specialities
    spec1 = Factory.create(:speciality)
    spec2 = Factory.create(:speciality)
    spec3 = Factory.create(:speciality)
    
    @staffer.specialities << spec1
    @staffer.specialities << spec2
    @staffer.specialities << spec3
    @staffer.save
     
    get :specialities,{:format=>:json, :id=>@staffer.id},authenticated_user(@badmin)
    #puts @response.body
    specs = ActiveSupport::JSON.decode(@response.body)
    assert_equal 3, specs.length 
    assert_equal 3, @staffer.specialities.length 
    
  end
  
  test "create new speciality" do
   assert_equal 0, @staffer.specialities.length
   spec1 = Factory.attributes_for(:speciality, :name=>"rino", :description=>"Nose jobs")
   assert_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :id=>@staffer.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_success("flash.success.speciality.create");
   staffer = Staffer.find(@staffer.id)
   assert_equal 1, staffer.specialities.length
 end
 
  test "dont create new speciality for invalid data" do
   assert_equal 0, @staffer.specialities.length
   spec1 = {:dummy=>"dsdd"}
   
   assert_no_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :id=>@staffer.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_error("flash.error.speciality.general");
   staffer = Staffer.find(@staffer.id)
   assert_equal 0, staffer.specialities.length
 end

  #Refactor this
  #A existing speciality should be assigned to the business if not alreday assigned
  test "dont create new speciality if same name" do
   specRino = Factory.create(:speciality, :name=>"rino")
   @staffer.specialities << specRino
   @staffer.save
   assert_equal 1, @staffer.specialities.length
   spec1 = Factory.attributes_for(:speciality, :name=>"rino", :description=>"Nose jobs")
   assert_no_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :id=>@staffer.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_error("flash.error.speciality.create.exists");
   staffer = Staffer.find(@staffer.id)
   assert_equal 1, staffer.specialities.length
 end
 
 test "delete speciality" do
    spec1 = Factory.create(:speciality) 
    @staffer.specialities << spec1
    @staffer.save
    staffer = Staffer.find(@staffer.id)
    assert_equal 1, staffer.specialities.length
    assert_no_difference('Speciality.count') do
      delete :specialities, {:format=>:json, :id=>@staffer.id,:speciality_id=>spec1.id}, authenticated_user(@badmin)   
    end
    assert_json_success("flash.success.speciality.delete");
    staffer = Staffer.find(@staffer.id)
    assert_equal 0, staffer.specialities.length
   
  end

##End testing specialities

end
