require 'test_helper'

class BusinessAdminTest < ActiveSupport::TestCase

  test "business admin can have multiple staffers" do
    #create a business admin
    business_admin = Factory.create(:business_admin)
    staffers_count = Staffer.count
    #create one worker
    staffer = Factory.create(:staffer, :business_admin_id=>business_admin.id)
    staffer = Factory.create(:staffer, :business_admin_id=>business_admin.id)
    staffer = Factory.create(:staffer, :business_admin_id=>business_admin.id)
    
    assert_equal 3+staffers_count, business_admin.staffers.count
    
    #has to remove them all
    business_admin.destroy
    assert_equal staffers_count, Staffer.count
    
  end
end
