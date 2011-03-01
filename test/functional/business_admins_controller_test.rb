require 'test_helper'

class BusinessAdminsControllerTest < ActionController::TestCase
 
 test "should get new page" do
    get :new
    assert_response :success
    assert_template "users/new"
  end
  
 test "should create new business admin" do
 
   badmin_params = Factory.attributes_for(:business_admin, :email=>"jota@jota.com")
   business_account_counter = BusinessAccount.count
   assert_difference('BusinessAdmin.count') do
      post :create, :business_admin=>badmin_params  
   end
   
   badmin = BusinessAdmin.find_by_email("jota@jota.com")
   assert_not_nil badmin
   assert_not_nil badmin.business_account
   
   assert_equal badmin.business_account.owner.id, badmin.id
 end
 
end
