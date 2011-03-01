require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  
  setup do
    @badmin = Factory.create(:business_admin)
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    @badmin.business_account = @baccount
    @badmin.save
        
  end
  # Replace this with your real tests.
  test "should show new without email" do
    get :new
    assert_response :success
    #no assign
    assert_nil assigns(:email)
    assert_nil assigns(:not_active)
  end
  

   
  test "should not create session for invalid info" do
    post :create, :session=>{:email=>"notvalid", :password=>"notvalid", :keep_logged=>false}
    assert_error_flashed "flash.error.session.invalid_data"
    assert_template :new
  end
  
  test "should not create session for inactice user" do
    
    user = Factory.create(:user, :active=>false)
    post :create, :session=>{:email=>user.email, :password=>"11111", :keep_logged=>false}
    assert_error_flashed "flash.error.session.inactive_user",{:email=>user.email}
    assert_template :new
  end
  
  test "should redirect business type user to businesses dashboard path" do
    
    user = Factory.create(:business_admin, :password=>"123456")
    post :create, :session=>{:email=>user.email, :password=>"123456", :keep_logged=>false}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to business_dashboard_path
    
  end
  test "should create session for active user no remember option" do
    #get an active user    
    user = Factory.create(:user, :password=>"123456")
    post :create, :session=>{:email=>user.email, :password=>"123456", :keep_logged=>false}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end
  
  test "should create session with remember option" do
    
    user = Factory.create(:user, :password=>"123456")
    post :create, :session=>{:email=>user.email, :password=>"123456", :keep_logged=>true}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
    #assert_equal [user.id, user.password_salt], cookies[:remember_me]
    
  end
  
  
  test "should destroy session with no remember option" do
    user = Factory.create(:user, :active=>false)
    
    delete :destroy, {}, authenticated_user(user)
    assert_nil session[:user_id]
    assert_redirected_to root_path
    assert_success_flashed "flash.success.session.destroy"
  end
  
  test "should not login inactive staffer" do
    badmin = Factory.create(:business_admin)
    staffer = Factory.create(:staffer, :active=>false, :password=>"123456", :business_account_id=>@badmin.business_account.id)
    post :create, :session=>{:email=>staffer.email, :password=>"123456", :keep_logged=>false}
    assert_error_flashed "flash.error.session.inactive_user",{:email=>staffer.email}
    assert_template :new    
  end
  test "should create session for sattfer" do
    
    badmin = Factory.create(:business_admin)
    
    staffer = Factory.create(:staffer, :email=>"pleasessseeeeme@example.com", :active=>true, :password=>"123456", :business_account_id=>@badmin.business_account.id)
    post :create, :session=>{:email=>staffer.email, :password=>"123456", :keep_logged=>false}
    assert_success_flashed "flash.success.session.create",{:email=>staffer.email}
    assert_equal staffer.id, session[:user_id]
    
    #assert_redirected_to business_dashboard_path
    
  end
  
  
end
