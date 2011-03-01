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
end
