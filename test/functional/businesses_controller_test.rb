require 'test_helper'

class BusinessesControllerTest < ActionController::TestCase
  setup do
    @valid_business = {
       :short_name =>"ClinicAd",
       :full_name =>"A clinica da beatriz, unhas e manicure",
       :description =>"Alguma descritpion aqui",
       :address =>"Address",
       :email =>"some@email.com",
       :phone =>"12345678",
       :fax =>"1234567", 
       :url =>"http://test.com",
       :facebook =>"http://facebook.com",
       :twitter =>"http://twitter.com"
      
    }
  end
  
  
  test "should not get dashboard not authenticated user" do
    user = users(:jonh)
    assert_raise(WebAppException::SessionRequiredError) do
      get :index,{},{}
    end
    
  end
  
  test "should not get dashboard not USER role" do
    user = users(:jonh)
    assert_raise(WebAppException::AuthorizationError) do
      get :index,{},authenticated_user(user)
    end
  end
  
  test "should get new page" do
    user = users(:bowner)
    get :new,{},authenticated_user(user)
    assert_template :new
    assert_not_nil assigns(:business)
  end
  
  
  test "should create business" do
    user = users(:bowner)
    assert_difference ('Business.count') do
      post :create, {:business=>@valid_business}, authenticated_user(user)  
    end
    assert_success_flashed "flash.sucess.business.create"
    assert_redirected_to business_dashboard_path
    #User must have now a business
    updated_user = User.find(user)
    assert_equal 1, updated_user.businesses.count 
  end
  
  
  
  
  
end
