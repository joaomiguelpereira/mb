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
  
end
