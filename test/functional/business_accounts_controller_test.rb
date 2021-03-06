require 'test_helper'

class BusinessAccountsControllerTest < ActionController::TestCase

  setup do
    @badmin = Factory.create(:business_admin)
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    @badmin.business_account = @baccount
    @badmin.save
    
    @otherbadmin = Factory.create(:business_admin)
    @otherbaccount = Factory.create(:business_account, :owner=>@otherbadmin)
    @otherbadmin.business_account = @otherbaccount
    @otherbadmin.save
    
    
  end
  test "cannot get the dashboard if not authenticated" do
    assert_raise(WebAppException::SessionRequiredError) do
      get :index,{},{}
    end
  end
  
  test "cannot get the dashboard if not business_admin" do
    user = Factory.create(:user)
    assert_raise(WebAppException::AuthorizationError) do
      get :index, {}, authenticated_user(user)
    end
  end
  
  test "get the dashboard for the business admin" do
    get :index, {:business_account_id=>@baccount.id}, authenticated_user(@badmin)
    assert_not_nil assigns(:business_account)
    assert_equal @baccount.id, assigns(:business_account).id
  end
  
  ####################Availability exception
  
  test "update availability exception" do
    json_data = Array.new
    #create two new exceptions
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_success("flash.success.business_account.availability_exceptions.update"); 
  end
  
  
  test "update availability more exception" do
    json_data = Array.new
    #create two new exceptions
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_success("flash.success.business_account.availability_exceptions.update"); 
  end
  
  test "update availability exception if dates same" do
    json_data = Array.new
    #create two new exceptions
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_success("flash.success.business_account.availability_exceptions.update"); 
  end

  test "update empty availability exception" do
    json_data = Array.new
    #create two new exceptions
    #json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_success("flash.success.business_account.availability_exceptions.update"); 
  end
  
   test "dont update nil availability exception" do
    json_data = ""
    #create two new exceptions
    #json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_error("flash.error.business_account.availability_exceptions.update"); 
  end
  

   test "dont update not valid availability exception" do
    json_data = Array.new
    #create two new exceptions
    json_data << {"start_date"=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"1/1/2002", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_error("flash.error.business_account.availability_exceptions.update")
  end

   test "do not update availability exception if dates wrong" do
    json_data = Array.new
    #create two new exceptions
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"12/12/2001", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"11/12/2001", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
    assert_json_error("flash.error.business_account.availability_exceptions.update") 
  end
  
  test "do not update availability exception if dates wrong format" do
    json_data = Array.new
    #create two new exceptions
    json_data << {Availability::EXCEPTION_START_DATE_FIELD_NAME=>"232323", Availability::EXCEPTION_END_DATE_FIELD_NAME=>"11111", Availability::EXCEPTION_MOTIVE_FIELD_NAME=>"Holidays, big ones", Availability::EXCEPTION_NOTES_FIELD_NAME=>"Some notes"}
    put :availability_exceptions, {:business_account_id=>@baccount.id, :json_data=>json_data.to_json} , authenticated_user(@badmin)
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
    put :availability, {:business_account_id=>@baccount.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
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
    
    put :availability, {:business_account_id=>@baccount.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
    assert_json_error("flash.error.business_account.availability.update"); 
      end
  
  test "get availability" do
    get :availability, {:business_account_id=>@baccount.id}, authenticated_user(@badmin)
    assert_not_nil assigns(:availability)
  end
  
  #########Test specialities
  
  test "dont get specialities if not authenticated" do 
     assert_raise(WebAppException::SessionRequiredError) do
      get :specialities,{:business_account_id=>@baccount.id},{}
    end
  end
  
  test "dont get specialities for other user" do  
    assert_raise(WebAppException::AuthorizationError) do
      get :specialities,{:business_account_id=>@baccount.id},authenticated_user(@otherbadmin)
    end
  end
  
  test "get specialities" do
    get :specialities,{:business_account_id=>@baccount.id},authenticated_user(@badmin)
    assert_not_nil assigns(:business_account)
    assert assigns(:specialities)  
  end
  
  test "get json specialities" do
    #create some specialities
    spec1 = Factory.create(:speciality)
    spec2 = Factory.create(:speciality)
    spec3 = Factory.create(:speciality)
    
    @baccount.specialities << spec1
    @baccount.specialities << spec2
    @baccount.specialities << spec3
    @baccount.save
     
    get :specialities,{:format=>:json, :business_account_id=>@baccount.id},authenticated_user(@badmin)
    #puts @response.body
    specs = ActiveSupport::JSON.decode(@response.body)
    assert_equal 3, specs.length 
    assert_equal 3, @baccount.specialities.length 
    
  end
  
  test "create new speciality" do
   assert_equal 0, @baccount.specialities.length
   spec1 = Factory.attributes_for(:speciality, :name=>"rino", :description=>"Nose jobs")
   assert_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :business_account_id=>@baccount.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_success("flash.success.speciality.create");
   bAccount = BusinessAccount.find(@baccount.id)
   assert_equal 1, bAccount.specialities.length
 end
 
  test "dont create new speciality for invalid data" do
   assert_equal 0, @baccount.specialities.length
   spec1 = {:dummy=>"dsdd"}
   
   assert_no_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :business_account_id=>@baccount.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_error("flash.error.speciality.general");
   bAccount = BusinessAccount.find(@baccount.id)
   assert_equal 0, bAccount.specialities.length
 end

  #Refactor this
  #A existing speciality should be assigned to the business if not alreday assigned
  test "dont create new speciality if same name" do
   specRino = Factory.create(:speciality, :name=>"rino")
   @baccount.specialities << specRino
   @baccount.save
   assert_equal 1, @baccount.specialities.length
   spec1 = Factory.attributes_for(:speciality, :name=>"rino", :description=>"Nose jobs")
   assert_no_difference ('Speciality.count') do
    post :specialities, {:format=>:json, :business_account_id=>@baccount.id,:speciality=>spec1.to_json}, authenticated_user(@badmin)  
   end
   assert_json_error("flash.error.speciality.create.exists");
   bAccount = BusinessAccount.find(@baccount.id)
   assert_equal 1, bAccount.specialities.length
 end
 
 test "delete speciality" do
    spec1 = Factory.create(:speciality) 
    @baccount.specialities << spec1
    @baccount.save
    bAccount = BusinessAccount.find(@baccount.id)
    assert_equal 1, bAccount.specialities.length
    assert_no_difference('Speciality.count') do
      delete :specialities, {:format=>:json, :business_account_id=>@baccount.id,:speciality_id=>spec1.id}, authenticated_user(@badmin)   
    end
    assert_json_success("flash.success.speciality.delete");
    bAccount = BusinessAccount.find(@baccount.id)
    assert_equal 0, bAccount.specialities.length
   
  end

end
