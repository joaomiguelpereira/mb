require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do 
    
    @update_valid_user_with_more_attrs = {
      :first_name=>"NewFirstName", :last_name=>"newLastName",
      
      :email=>"udpate@emai.com"
    }
    
    @update_valid_user = {
      :first_name=>"NewFirstName", :last_name=>"newLastName"
    }
    
    @update_invalid_user = {
      :first_name=>"1", :last_name=>"1"
    }
    
    @new_valid_user = {
      :first_name=>"Jonh", :last_name=>"F. Kenedy", 
      :email=>"jfk@gmail.com", :email_confirmation=>"jfk@gmail.com", 
      :password=>"123456", :password_confirmation=>"123456", 
      :terms_and_conditions=>"1",
      
    }
    @new_invalid_user = {
      :first_name=>"Jonh", :last_name=>"Remedy", 
      :email=>"jr@gmail.com", :email_confirmation=>"jr@gmail.com", 
      :password=>"123456", :password_confirmation=>"123456", 
      :terms_and_conditions=>"1"
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
    
    invalid_user = Factory.attributes_for(:user, :first_name=>"N", :last_name=>"n")
    assert_no_difference('User.count') do
      post :create, :user=>invalid_user  
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

    user = Factory.create(:user, :active=>false, :activation_key=>"12172671627617267162716726176jsh")
    assert !user.need_new_password, "need password should be false"
    
    get :activate, :activation_key=>user.activation_key
    assert_success_flashed "flash.success.user.activate", {:email=>user.email}
    assert_redirected_to new_session_path
    
    active_user = User.find(user.id)
    #activation key should be now nil
    assert_nil active_user.activation_key 
    #user should be active
    assert active_user.active
  end
  
  
  
  test "should create new user" do
    user =   Factory.attributes_for(:user)

    assert_difference('User.count') do
      post :create, :user=>user  
    end
    assert_redirected_to new_session_path()
    #assert_notice_flashed ""
    assert_success_flashed "flash.success.user.create"
    user = User.find_by_email(user[:email])
    assert_not_nil user
    assert  !user.active
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
    
    user = Factory.create(:user, :active=>false, :activation_key=>"12172671627617267162716726176jsh")
    
    post :reset_password, :reset_password=>{:email=>user.email}
    assert_template :reset_password
    assert_error_flashed "flash.error.user.reset_password_inactive_user", {:email=>user.email}
  end
  
  test "should start reset password process" do

    user = Factory.create(:user)
    
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
    user = Factory.create(:user, :reset_password_key=>"1234321qwerewqassdert")
    
    get :create_new_password, :reset_password_key=>user.reset_password_key
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :create_new_password
    #assert_not_nil assigns(:user)
  end
  
  test "should not create new password for valid key with weak pass" do
    user = Factory.create(:user, :reset_password_key=>"1234321qwerewqassdert")
    put :create_new_password, {:user=>{:password=>"1", :password_confirmation=>"1"}, :reset_password_key=>user.reset_password_key} 
    assert_error_flashed "flash.error.user.create_new_password"
    assert_template :create_new_password
  end

  test "should not create new password for valid key without correct pass conf" do
    user = Factory.create(:user, :reset_password_key=>"1234321qwerewqassdert")
    put :create_new_password, {:user=>{:password=>"654321", :password_confirmation=>"123456"}, :reset_password_key=>user.reset_password_key} 
    assert_error_flashed "flash.error.user.create_new_password"
    assert_template :create_new_password
  end


  test "should not create new password for invalid key but valid pass" do
    user = Factory.create(:user, :reset_password_key=>"1234321qwerewqassdert")
    put :create_new_password, {:user=>{:password=>"123456", :password_confirmation=>"123456"}, :reset_password_key=>user.reset_password_key+"22"} 
    assert_error_flashed "flash.error.general.invalid_operation"
    assert_redirected_to root_path
  end

  test "should create new password " do
    user = Factory.create(:user, :reset_password_key=>"1234321qwerewqassdert")
    
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
  
  
  #################################################
  #### View User Profile
  #################################################
  test "should not get profile page for unauthenticated user" do
    
    assert_raise(WebAppException::SessionRequiredError) do 
      get :profile 
    end
  end
  
  test "should get the profile page for the authenticated user" do
    user = Factory.create(:user)
    get :profile, {},  authenticated_user(user) 
    assert_not_nil assigns(:user)
    assert_equal user.id, assigns(:user).id
    assert_template :profile
  end
  
  #################################################
  #### Update user
  ################################################
  test "should not get edit user if not authenticated" do
    user = Factory.create(:user)
    assert_raise(WebAppException::SessionRequiredError) do 
      get :edit, {:id=>user.id}, {}  
    end
  end

  test "should not get edit user if not authorized" do
    jonh = Factory.create(:user)
    sam = Factory.create(:user)
    assert_raise(WebAppException::AuthorizationError) do 
      get :edit, {:id=>jonh.id},authenticated_user(sam)  
    end
  end

  test "should not update user is not authenticated" do
    user = Factory.create(:user)
    
    assert_raise(WebAppException::SessionRequiredError) do 
      put :update, {:id=>user.id, :user=>@update_valid_user}, {}  
    end
  end
  
  test "should not update is authenticated user id different" do
    jonh = Factory.create(:user)
    sam = Factory.create(:user)
    assert_raise(WebAppException::AuthorizationError) do 
      put :update, {:id=>jonh.id, :user=>@update_valid_user}, authenticated_user(sam)  
    end
  end
  
  test "should update" do
    jonh = Factory.create(:user)
    put :update, {:id=>jonh.id, :user=>@update_valid_user}, authenticated_user(jonh)  
    assert_success_flashed "flash.success.user.update"
    assert_redirected_to user_profile_path
    #get the user
    updated_user = User.find(jonh.id)    
    assert_equal @update_valid_user[:first_name], updated_user.first_name
    assert_equal @update_valid_user[:last_name], updated_user.last_name
  end
  
   test "should not update invalid data" do
    jonh = Factory.create(:user)
    put :update, {:id=>jonh.id, :user=>@update_invalid_user}, authenticated_user(jonh)  
    assert_error_flashed "flash.error.user.update"
    assert_template :edit
  end
  
  test "shoul not update unapdatable data" do
    jonh = Factory.create(:user)
    put :update, {:id=>jonh.id, :user=>@update_valid_user_with_more_attrs}, authenticated_user(jonh)  
    assert_success_flashed "flash.success.user.update"
    assert_redirected_to user_profile_path
    #get the user
    
    updated_user = User.find(jonh.id)    
    assert_equal @update_valid_user_with_more_attrs[:first_name], updated_user.first_name
    assert_equal @update_valid_user_with_more_attrs[:last_name], updated_user.last_name
    
    #not updatable attributes
    assert_equal jonh.email, updated_user.email
   
    
  end
  
  #####################################3
  ###Change password
  ######################################
  
  test "should not get change password page is not authenticated" do
     assert_raise(WebAppException::SessionRequiredError) do 
       get :change_password, {}, {}   
     end
  end
  test "should get the change password page if authenticated" do
    jonh = Factory.create(:user)
    get :change_password, {}, authenticated_user(jonh)   
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :change_password
  end
  
  test "shoudl not update password for invalid password" do
    jonh = Factory.create(:user)
    put :change_password, {:user=>{:password=>"1", :password_confirmation=>"1"}}, authenticated_user(jonh)   
    
    assert_not_nil assigns(:user)
    assert_template :change_password
    assert_error_flashed "flash.error.user.create_new_password"

  end

  test "shoudl not update password for invalid password confirmation" do
    jonh = Factory.create(:user)
    put :change_password, {:user=>{:password=>"123456", :password_confirmation=>"654321"}}, authenticated_user(jonh)   
    
    assert_not_nil assigns(:user)
    assert_template :change_password
    assert_error_flashed "flash.error.user.create_new_password"

  end

  test "shoudl update password for valid password" do
    jonh = Factory.create(:user)
    put :change_password, {:user=>{:password=>"123456", :password_confirmation=>"123456"}}, authenticated_user(jonh)   
    assert_redirected_to user_profile_path
    assert_success_flashed "flash.success.user.create_new_password"

    #must change also the cookie...
  end


   test "should ask new password after activation" do
      badmin = Factory.create(:business_admin)
      #create business_account
      baccount = Factory.create(:business_account, :owner=>badmin)
      staffer = Factory.create(:staffer, :business_account=>baccount, :active=>false, :need_new_password=>true)
      assert_not_nil staffer.activation_key
      
      get :activate, :activation_key=>staffer.activation_key
      assert_success_flashed "flash.success.user.activate", {:email=>staffer.email}
      active_user = User.find(staffer.id)
      #activation key should be now nil
      assert_nil active_user.activation_key 
      #user should be active
      assert active_user.active
      assert_not_nil active_user.reset_password_key
      assert_redirected_to create_new_password_path(active_user.reset_password_key)
  end


end
