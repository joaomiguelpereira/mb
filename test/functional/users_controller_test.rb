require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do 
    @new_valid_user = {
      :first_name=>"Jonh", :last_name=>"F. Kenedy", 
      :email=>"jfk@gmail.com", :email_confirmation=>"jfk@gmail.com", 
      :password=>"123456", :password_confirmation=>"123456", 
      :terms_and_conditions=>"1",
      :role=>User::BUSINESS_OWNER
    }
    @new_invalid_user = {
      :first_name=>"Jonh", :last_name=>"Remedy", 
      :email=>"jr@gmail.com", :email_confirmation=>"jr@gmail.com", 
      :password=>"123456", :password_confirmation=>"123456", 
      :terms_and_conditions=>"1",
      :role=>"what"
    } 
  end
  ##################################################
  ####Create new User
  ##################################################

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    
  end
  
  test "should not create new user" do
    
    assert_no_difference('User.count') do
      post :create, :user=>@new_invalid_user  
    end
    assert_error_flashed "flash.error.user.create"
    assert_template :new
  end
  
  test "should not activate user for invalid key" do
    get :activate, :activation_key=>"somedummy_key"
    assert_error_flashed "flash.error.user.activate"
    assert_redirected_to root_path
  end
  
  test "should activate user" do
    user = users(:not_active)
    get :activate, :activation_key=>user.activation_key
    assert_success_flashed "flash.success.user.activate", {:email=>user}
    assert_redirected_to new_session_path
    
    active_user = User.find(user.id)
    #activation key should be now nil
    assert_nil active_user.activation_key 
    #user should be active
    assert active_user.active
  end
  
  
  
  test "should create new user" do
    assert_difference('User.count') do
      post :create, :user=>@new_valid_user  
    end
    assert_redirected_to new_session_path(:email=>"jfk@gmail.com")
    assert_success_flashed "flash.success.user.create"
    user = User.find_by_email("jfk@gmail.com")
    assert_not_nil user
    #assert mail sent
    assert !ActionMailer::Base.deliveries.empty?
    #get the last sent email
    email = ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.size-1]
     # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_equal I18n.t("mailer.user.activation.subject"), email.subject
    assert_match /#{user.full_name}/, email.encoded
    #check if the activation key is there
    assert_match /#{user.activation_key}/, email.encoded
  end
  
  
  ##################################################
  ####RESET PASSWORD
  ##################################################
  
  test "should get reset password page" do
    get :reset_password
    assert_response :success
    assert_template :reset_password
  end
  
  test "should fail reset password for empty password" do
    post :reset_password, :reset_password=>{:email=>nil}
    assert_template :reset_password
    assert_error_flashed "flash.error.user.reset_password_empty_email"
  end
  
  test "should fail reset password for non existing password" do
    post :reset_password, :reset_password=>{:email=>"somemail"}
    assert_template :reset_password
    assert_error_flashed "flash.error.user.reset_password_email_not_found", {:email=>"somemail"}
  end
  
  test "should not reset password for inactive user" do
    user = users(:not_active)
    post :reset_password, :reset_password=>{:email=>user.email}
    assert_template :reset_password
    assert_error_flashed "flash.error.user.reset_password_inactive_user", {:email=>user.email}
  end
  
  test "should start reset password process" do
    user = users(:jonh)
    post :reset_password, :reset_password=>{:email=>user.email}
    assert_redirected_to root_path
    assert_success_flashed "flash.success.user.reset_password", {:email=>user.email}
    target_user = User.find(user.id)
    assert_not_nil target_user.reset_password_key
    #should have sent an email
    assert !ActionMailer::Base.deliveries.empty?
    #get the last sent email
    email = ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.size-1]
     # Test the body of the sent email contains what we expect it to
    assert_equal [target_user.email], email.to
    assert_equal I18n.t("mailer.user.reset_password.subject"), email.subject
    assert_match /#{target_user.full_name}/, email.encoded
    #check if the activation key is there
    #won't do this now.
    #TODO: COmplete
    #assert_match /#{target_user.reset_password_key}/, email.encoded
  end
  
  test "should not get create new password page for empty reset_password_key" do
    get :create_new_password, {:reset_password_key=>"somekey"}
    assert_error_flashed "flash.error.general.invalid_operation"
    assert_redirected_to root_path
  end
  
  test "should get create new password page" do
    user = users(:jonh)
    get :create_new_password, :reset_password_key=>user.reset_password_key
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :create_new_password
    #assert_not_nil assigns(:user)
  end
  
  test "should not create new password for valid key with weak pass" do
    user = users(:jonh)
    put :create_new_password, {:user=>{:password=>"1", :password_confirmation=>"1"}, :reset_password_key=>user.reset_password_key} 
    assert_error_flashed "flash.error.user.create_new_password"
    assert_template :create_new_password
  end

  test "should not create new password for valid key without correct pass conf" do
    user = users(:jonh)
    put :create_new_password, {:user=>{:password=>"654321", :password_confirmation=>"123456"}, :reset_password_key=>user.reset_password_key} 
    assert_error_flashed "flash.error.user.create_new_password"
    assert_template :create_new_password
  end


  test "should not create new password for invalid key but valid pass" do
    user = users(:jonh)
    put :create_new_password, {:user=>{:password=>"123456", :password_confirmation=>"123456"}, :reset_password_key=>user.reset_password_key+"22"} 
    assert_error_flashed "flash.error.general.invalid_operation"
    assert_redirected_to root_path
  end

  test "should create new password " do
    user = users(:jonh)
    
    put :create_new_password, {:user=>{:password=>"123456", :password_confirmation=>"123456"}, :reset_password_key=>user.reset_password_key} 
    assert_success_flashed "flash.success.user.create_new_password"
    assert_redirected_to new_session_path
    #reset password key, should be nil now
    updated_user = User.find(user.id)
    assert_nil updated_user.reset_password_key 
  end

  test "should not create new password for invalid key" do
    put :create_new_password, {:user=>{:password=>"1", :password_confirmation=>"1"}, :reset_password_key=>"someinv_alidke"} 
    assert_error_flashed "flash.error.general.invalid_operation"
    assert_redirected_to root_path
  end
  
  
  
  ##################################################
  ####Change User
  ##################################################
  
  test "should not get edit user if no session exists" do
    user = users(:jonh)
    assert_raise(WebAppException::SessionRequiredError) do 
      get :edit, {:id=>user.id}  
    end
  end
  
  test "should not get edit user is session exists but wrong user is logged in" do
    jonh = users(:jonh)
    sam = users(:sam)
      assert_raise(WebAppException::AuthorizationError) do 
      get :edit, {:id=>sam.id}, authenticated_user(jonh)  
    end
  end
  

end
