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
  
  test "should not get admin list page for othen than the authorized user" do
        
    assert_raise (WebAppException::AuthorizationError) do
      get :index, {:business_account_id=>@badmin.business_account.id}, authenticated_user(@other_badmin)
    end
  end
  
  
  test "should not get new admin page for not authenticated user" do
    assert_raise(WebAppException::SessionRequiredError) do 
      get :new , {:business_account_id=>12}
    end
  end
  
  test "should not get new admin  page for other than the authorized user" do
    
    assert_raise (WebAppException::AuthorizationError) do
      get :new, {:business_account_id=>@badmin.business_account.id}, authenticated_user(@other_badmin)
    end
  end

  #########################################################
  ####Create
  #########################################################
  
  test "should not create a admin for not authenticated user" do
    
    admin = Factory.attributes_for(:business_admin)
    assert_raise( WebAppException::SessionRequiredError) do
      post :create, {:business_account_id=>@badmin.business_account.id, :business_admin=>admin}, {}
    end
  end
  
  test "should not create a admin for other business admin" do
    admin = Factory.attributes_for(:business_admin)
    assert_raise( WebAppException::AuthorizationError) do
      post :create, {:business_account_id=>@badmin.business_account.id, :business_admin=>admin}, authenticated_user(@other_badmin)
    end
  end
  
  test "should not create a invalid admin" do
    admin = Factory.attributes_for(:business_admin, :email=>"", :password=>"", :active=>false)
    post :create, {:business_account_id=>@badmin.business_account.id, :business_admin=>admin}, authenticated_user(@badmin)
    assert_error_flashed "flash.error.admin.create"
    assert_template :new
  end
  
  test "should create a admin but not notify" do
    email_sents = ActionMailer::Base.deliveries.size
    
    admin = Factory.attributes_for(:business_admin, :email=>"justfindme@mail.com", :password=>"", :active=>false, :notify_on_create=>false)
    post :create, {:business_account_id=>@badmin.business_account.id, :business_admin=>admin}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.admin.create"
    assert_equal email_sents, ActionMailer::Base.deliveries.size, "should have sent no email"
    #get the saved staffer
    
    new_admin = BusinessAdmin.find_by_email("justfindme@mail.com")
    assert_not_nil new_admin
    assert_equal new_admin.created_by, @badmin.id
    assert !new_admin.active
  end

  test "should create a new staffer and auto notify" do
    
    
    email_sents = ActionMailer::Base.deliveries.size
    
    admin = Factory.attributes_for(:business_admin, :email=>"otherstaff@mail.com", :password=>"", :active=>false, :notify_on_create=>true)
    post :create, {:business_account_id=>@badmin.business_account.id, :business_admin=>admin}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.admin.create"
    assert_equal email_sents+1, ActionMailer::Base.deliveries.size, "should have sent  email"
    #get the saved staffer
    
    new_admin = BusinessAdmin.find_by_email("otherstaff@mail.com")
    assert_not_nil new_admin
    assert !new_admin.active
    assert new_admin.need_new_password
    assert_equal new_admin.created_by, @badmin.id
    
    #assert mail sent   
    assert !ActionMailer::Base.deliveries.empty?
    #get the last sent email
    email = ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.size-1]
     # Test the body of the sent email contains what we expect it to
    assert_equal [new_admin.email], email.to
    assert_equal I18n.t("mailer.admin.activation.subject"), email.subject
    assert_match /#{new_admin.full_name}/, email.encoded
    assert_match /#{@badmin.full_name}/, email.encoded
    
    #check if the activation key is there
    assert_match /#{new_admin.activation_key}/, email.encoded
    ###end mail assertion
  end
  ##################################
  ##Send activation teste
  ###################################
  test "dont send activation email to active user" do
    admin = Factory.create(:business_admin, :business_account=>@badmin.business_account, :active=>true)
    put :send_activation_email, {:business_account_id=>@badmin.business_account.id, :id=>admin.id, :format=>:js}, authenticated_user(@badmin)
    assert_error_flashed "flash.error.admin.send_activation_mail_active"  
  end
  
  test "send activation email to inactive user" do
    admin = Factory.create(:business_admin, :business_account=>@baccount, :active=>false, :activation_key=>"1234", :email=>"some@example.com")
    email_sent = ActionMailer::Base.deliveries.size
    put :send_activation_email, {:business_account_id=>@badmin.business_account.id, :id=>admin.id, :format=>:js}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.admin.send_activation_mail", {:email=>admin.email}
    
    assert_equal email_sent+1, ActionMailer::Base.deliveries.size, "should have sent  email"
     #assert mail sent   
    assert !ActionMailer::Base.deliveries.empty?
    #get the last sent email
    email = ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.size-1]
     # Test the body of the sent email contains what we expect it to
    assert_equal [admin.email], email.to
    assert_equal I18n.t("mailer.admin.activation.subject"), email.subject
    assert_match /#{admin.full_name}/, email.encoded
    assert_match /#{@badmin.full_name}/, email.encoded
    #check if the activation key is there
    assert_match /#{admin.activation_key}/, email.encoded
    ###end mail assertion
   
   end
end
