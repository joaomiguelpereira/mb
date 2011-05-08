require 'test_helper'

class BusinessAccounts::AppointmentsControllerTest < ActionController::TestCase
	setup do
		@badmin = Factory.create(:business_admin)
		@other_badmin = Factory.create(:business_admin)
		@controller = BusinessAccounts::StaffersController.new
		@baccount = Factory.create(:business_account, :owner=>@badmin)
		@badmin.business_account = @baccount
		@badmin.save!
	end

	###################################################
	### Basic authentication and authorization tests
	###################################################

	test "should not get appointments list page for not authenticated user" do
		assert_raise(WebAppException::SessionRequiredError) do
			get :index , {:business_account_id=>12}
		end
	end

	test "should not get appointments list page for othen than the authorized user" do

		assert_raise (WebAppException::AuthorizationError) do
			get :index, {:business_account_id=>@badmin.business_account.id}, authenticated_user(@other_badmin)
		end
	end

end
