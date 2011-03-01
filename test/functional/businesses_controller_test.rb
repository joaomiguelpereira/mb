require 'test_helper'

class BusinessesControllerTest < ActionController::TestCase
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
  
  test "should get new page" do
    get :new,{:business_account_id=>@badmin.business_account},authenticated_user(@badmin)
    assert_template :new
    assert_not_nil assigns(:business)
  end
  
  test "should not show business fo other than an admin" do

     business = Factory.create(:business, :business_account_id=>@badmin.business_account.id)
     assert_raise(WebAppException::AuthorizationError) do
       get :show, {:business_account_id=>@badmin.business_account.id, :id=>business.id}, authenticated_user(@otherbadmin)
     end
  end
  
  test "should create business" do

    
    valid_business = Factory.attributes_for(:business)
    
    assert_difference ('Business.count') do
      post :create, {:business_account_id=>@badmin.business_account.id, :business=>valid_business}, authenticated_user(@badmin)  
    end
    assert_success_flashed "flash.success.business.create"
    assert_redirected_to business_dashboard_path
    #User must have now a business
    #updated_user = User.find(user)
    #assert_equal 1, updated_user.businesses.count 
  end
  
  test "should not get edit form for not business owner" do
     
     business = Factory.create(:business, :business_account_id=>@badmin.business_account.id)   
     assert_raise(WebAppException::AuthorizationError) do
       get :edit, {:business_account_id=>@badmin.business_account.id, :id=>business.id}, authenticated_user(@otherbadmin)
     end
  end
  
  
  test "should not update short name" do
    
    business = Factory.create(:business, :business_account_id=>@badmin.business_account.id)
    old = business.short_name
    put :update, {:business_account_id=>@badmin.business_account.id, :business=>{:short_name=>"somenewname"},:id=>business.id}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.business.update"
    updated_business = Business.find(business.id)
    assert_equal old, updated_business.short_name
    
  end
  
  
  
end
