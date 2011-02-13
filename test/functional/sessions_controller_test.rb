require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should show new without email" do
    get :new
    assert_response :success
    #no assign
    assert_nil assigns(:email)
    assert_nil assigns(:not_active)
  end
  
  test "should show new with email only" do
    get :new, :email=>"someemail@gmail.com"
    assert_response :success
    assert_equal "someemail@gmail.com", assigns(:email)
    assert_nil assigns(:not_active)
    
  end
  
  test "should show new email with post registerd message" do 
    user = users(:not_active)
    get :new, :email=>user.email
    assert assigns(:not_active)
    assert_equal assigns(:email), user.email
  end
  
  test "should not create session for invalid info" do
    post :create, :session=>{:email=>"notvalid", :password=>"notvalid", :keep_logged=>false}
    assert_error_flashed "flash.error.session.invalid_data"
    assert_template :new
  end
  
  test "should not create session for inactice user" do
    user = users(:not_active)
    post :create, :session=>{:email=>user.email, :password=>"11111", :keep_logged=>false}
    assert_error_flashed "flash.error.session.inactive_user",{:email=>user.email}
    assert_template :new
  end
  
  test "should redirect business type user to businesses dashboard path" do
    user = users(:bowner)
    post :create, :session=>{:email=>user.email, :password=>"11111", :keep_logged=>false}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to business_dashboard_path
    
  end
  test "should create session for active user no remember option" do
    #get an active user    
    user = users(:jonh)
    post :create, :session=>{:email=>user.email, :password=>"11111", :keep_logged=>false}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end
  
  test "should create session with remember option" do
    user = users(:jonh)
    post :create, :session=>{:email=>user.email, :password=>"11111", :keep_logged=>true}
    assert_success_flashed "flash.success.session.create",{:email=>user.email}
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
    #assert_equal [user.id, user.password_salt], cookies[:remember_me]
    
  end
  
  
  test "should destroy session with no remember option" do
    delete :destroy, {}, authenticated_user(users(:jonh))
    assert_nil session[:user_id]
    assert_redirected_to root_path
    assert_success_flashed "flash.success.session.destroy"
  end
  
  
  
  
end
