require 'test_helper'

class BusinessAccountsControllerTest < ActionController::TestCase

  setup do
    @badmin = Factory.create(:business_admin)
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    @badmin.business_account = @baccount
    @badmin.save
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
    get :index, {}, authenticated_user(@badmin)
    assert_not_nil assigns(:business_account)
    assert_equal @baccount.id, assigns(:business_account).id
  end
  
  test "update availability" do
    json_data_array = Array.new
    for i in (0..(Availability::WEEK_DAYS-1))
      day_array = Array.new
      day_array << {Availability::START_HOUR_FIELD_NAME=>30, Availability::END_HOUR_FIELD_NAME=>120, Availability::WEEK_DAY_FIELD_NAME=>i}
      
      day_array << {Availability::START_HOUR_FIELD_NAME=>150, Availability::END_HOUR_FIELD_NAME=>210, Availability::WEEK_DAY_FIELD_NAME=>i}
      
      json_data_array << day_array
    end
    put :availability, {:business_account_id=>@badmin.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.business_account.availability.update"
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
    
    put :availability, {:business_account_id=>@badmin.id, :json_data=>json_data_array.to_json}, authenticated_user(@badmin)
    assert_error_flashed "flash.error.business_account.availability.update"
  end
  
  test "get availability" do
    
    get :availability, {:business_account_id=>@badmin.id}, authenticated_user(@badmin)
    assert_not_nil assigns(:availability)
    
  end
end
