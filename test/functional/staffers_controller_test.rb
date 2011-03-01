require 'test_helper'

class StaffersControllerTest < ActionController::TestCase
  
  
  
  setup do  
    @badmin = Factory.create(:business_admin)
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    @badmin.business_account = @baccount
    @badmin.save
  end
  
  
 ########################################
   #### Test show dashboard
   ########################################
   test "should not show staffer dashboard for not authenticated user" do
     staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
     assert_raise( WebAppException::SessionRequiredError) do
      get :dashboard, {:id=>staffer.id}, {}
    end
  end
  
   test "should not show staffer dashboard for not correct authenticated user" do
     staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
     fake = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
     assert_raise( WebAppException::AuthorizationError) do
       get :dashboard, {:id=>staffer.id}, authenticated_user(fake)
    end

   end 

     test "should  show staffer dashboard for  correct authenticated user" do
     staffer = Factory.create(:staffer, :business_account=>@baccount, :active=>true)
     
     
    get :dashboard, {:id=>staffer.id}, authenticated_user(staffer)
    assert_template :dashboard
    assert_not_nil assigns(:staffer)

    end


end
