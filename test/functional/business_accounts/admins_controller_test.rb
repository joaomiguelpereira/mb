require 'test_helper'

class BusinessAccounts::AdminsControllerTest < ActionController::TestCase
  setup do
    @badmin = Factory.create(:business_admin)  
    @other_badmin = Factory.create(:business_admin)
    @controller = BusinessAccounts::AdminsController.new
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    @badmin.business_account = @baccount
    @badmin.save!
  end
  
  ###################################################
  ### Basic authentication and authorization tests
  ###################################################
  test "should not get business_account_admins list page for not authenticated user" do
     assert_raise(WebAppException::SessionRequiredError) do 
      get :index , {:business_account_id=>12}
    end
  end
  
end
