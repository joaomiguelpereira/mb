require 'test_helper'

class StaffersControllerTest < ActionController::TestCase
  
  ##################
  ### Basic authentication and authorization tests
  test "should not get staffer list page for not authenticated user" do
     assert_raise(WebAppException::SessionRequiredError) do 
      get :index , {:business_admin_id=>12}
    end
  end
  
  test "should not get staffer list page for othen than the authorized user" do
    admin = Factory.create(:business_admin)
    fake_admin = Factory.create(:business_admin)
    
    assert_raise (WebAppException::AuthorizationError) do
      get :index, {:business_admin_id=>admin.id}, authenticated_user(fake_admin)
    end
  end
  
end
