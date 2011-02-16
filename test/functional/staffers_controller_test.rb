require 'test_helper'

class StaffersControllerTest < ActionController::TestCase
  
  setup do
    @badmin = Factory.create(:business_admin)  
    @other_badmin = Factory.create(:business_admin)
  end
  ###################################################
  ### Basic authentication and authorization tests
  ###################################################
  test "should not get staffer list page for not authenticated user" do
     assert_raise(WebAppException::SessionRequiredError) do 
      get :index , {:business_admin_id=>12}
    end
  end
  
  test "should not get staffer list page for othen than the authorized user" do
    #admin = Factory.create(:business_admin)
    
    #fake_admin = Factory.create(:business_admin)
    
    assert_raise (WebAppException::AuthorizationError) do
      get :index, {:business_admin_id=>@badmin.id}, authenticated_user(@other_badmin)
    end
  end
  
  test "should not get new staffer page for not wuthenticated user" do
    assert_raise(WebAppException::SessionRequiredError) do 
      get :new , {:business_admin_id=>12}
    end
  end
  
  test "should not get new staffer  page for other than the authorized user" do
    #admin = Factory.create(:business_admin)
    #fake_admin = Factory.create(:business_admin)
    
    assert_raise (WebAppException::AuthorizationError) do
      get :new, {:business_admin_id=>@badmin.id}, authenticated_user(@other_badmin)
    end
  end
  
  #########################################################
  ####Create
  #########################################################
  
  test "should not create a staffer for unaquthenticated user" do
    #badmin = Factory.create(:business_admin)
    
    staffer = Factory.attributes_for(:staffer)
    assert_raise( WebAppException::SessionRequiredError) do
      post :create, {:business_admin_id=>@badmin.id, :staffer=>staffer}, {}
    end
  end
  
  test "should not create a staffer for other business admin" do
    staffer = Factory.attributes_for(:staffer)
    assert_raise( WebAppException::AuthorizationError) do
      post :create, {:business_admin_id=>@badmin.id, :staffer=>staffer}, authenticated_user(@other_badmin)
    end
  end
  
  test "should not create a invalid staffer" do
    staffer = Factory.attributes_for(:staffer, :email=>"", :password=>"", :active=>false)
    post :create, {:business_admin_id=>@badmin.id, :staffer=>staffer}, authenticated_user(@badmin)
    assert_error_flashed "flash.error.staffer.create"
    assert_template :new
  end
  
  test "should create a staffer but not notify" do
    email_sents = ActionMailer::Base.deliveries.size
    
    staffer = Factory.attributes_for(:staffer, :email=>"justfindme@mail.com", :password=>"", :active=>false, :notify_on_create=>false)
    post :create, {:business_admin_id=>@badmin.id, :staffer=>staffer}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.staffer.create"
    assert_equal email_sents, ActionMailer::Base.deliveries.size, "should have sent no email"
    #get the saved staffer
    
    new_staffer = Staffer.find_by_email("justfindme@mail.com")
    assert_not_nil new_staffer
    assert !new_staffer.active
  end

  test "should create a new staffer and auto notify" do
    
    
    email_sents = ActionMailer::Base.deliveries.size
    
    staffer = Factory.attributes_for(:staffer, :email=>"otherstaff@mail.com", :password=>"", :active=>false, :notify_on_create=>true)
    post :create, {:business_admin_id=>@badmin.id, :staffer=>staffer}, authenticated_user(@badmin)
    assert_success_flashed "flash.success.staffer.create"
    assert_equal email_sents+1, ActionMailer::Base.deliveries.size, "should have sent  email"
    #get the saved staffer
    
    new_staffer = Staffer.find_by_email("otherstaff@mail.com")
    assert_not_nil new_staffer
    assert !new_staffer.active
    assert new_staffer.need_new_password
    
    
    #assert mail sent   
    assert !ActionMailer::Base.deliveries.empty?
    #get the last sent email
    email = ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.size-1]
     # Test the body of the sent email contains what we expect it to
    assert_equal [new_staffer.email], email.to
    assert_equal I18n.t("mailer.staffer.activation.subject"), email.subject
    assert_match /#{new_staffer.full_name}/, email.encoded
    assert_match /#{@badmin.full_name}/, email.encoded
    
    #check if the activation key is there
    assert_match /#{new_staffer.activation_key}/, email.encoded
    ###end mail assertion
  end
  
 
  
end
