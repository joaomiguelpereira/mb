require 'test_helper'

class BusinessesControllerTest < ActionController::TestCase
  
  
  test "should not get dashboard not authenticated user" do
    
    assert_raise(WebAppException::SessionRequiredError) do
      get :index,{},{}
    end
    
  end
  
  test "should not get dashboard not USER role" do
    user = Factory.create(:user)
    assert_raise(WebAppException::AuthorizationError) do
      get :index,{},authenticated_user(user)
    end
  end
  
  test "should get new page" do
    user =  Factory.create(:business_admin)
    get :new,{:business_admin_id=>user.id},authenticated_user(user)
    assert_template :new
    assert_not_nil assigns(:business)
  end
  test "should not show business fo other than owner" do
     owner = Factory.create(:business_admin)
     business = Factory.create(:business, :business_admin_id=>owner.id)
     other = Factory.create(:business_admin)
     
     assert_raise(WebAppException::AuthorizationError) do
       get :show, {:business_admin_id=>owner.id, :id=>business.id}, authenticated_user(other)
     end
  end
  
  test "should create business" do
    user = Factory.create(:business_admin)
    valid_business = Factory.attributes_for(:business, :business_admin_id=>user.id)
    
    assert_difference ('Business.count') do
      post :create, {:business_admin_id=>user.id, :business=>valid_business}, authenticated_user(user)  
    end
    assert_success_flashed "flash.success.business.create"
    assert_redirected_to business_dashboard_path
    #User must have now a business
    updated_user = User.find(user)
    assert_equal 1, updated_user.businesses.count 
  end
  
  test "should not get edit form for not business owner" do
     owner = Factory.create(:business_admin)
     business = Factory.create(:business, :business_admin_id=>owner.id)
     
     
     other = Factory.create(:business_admin)
     
     assert_raise(WebAppException::AuthorizationError) do
       get :edit, {:business_admin_id=>owner.id, :id=>business.id}, authenticated_user(other)
     end
  end
  
  
  test "should not update short name" do
    owner = Factory.create(:business_admin)
    business = Factory.create(:business, :business_admin_id=>owner.id)
    old = business.short_name
    put :update, {:business_admin_id=>owner.id, :business=>{:short_name=>"somenewname"},:id=>business.id}, authenticated_user(owner)
    assert_success_flashed "flash.success.business.update"
    updated_business = Business.find(business.id)
    assert_equal old, updated_business.short_name
    
  end
  
  
  
end
