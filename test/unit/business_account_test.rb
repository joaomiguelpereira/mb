require 'test_helper'

class BusinessAccountTest < ActiveSupport::TestCase
  
  test "business account can have one business" do
    business_admin = Factory.create(:business_admin)
    baccount = Factory.create(:business_account, :owner=>business_admin)
    business = Factory.create(:business)
    baccount.business = business
    baccount.save
  end
  
  test "business account can have multiple staffers" do
    #create a business admin
    business_admin = Factory.create(:business_admin)
    baccount = Factory.create(:business_account, :owner=>business_admin)
    staffers_count = Staffer.count
    #create one worker
    staffer = Factory.create(:staffer, :business_account_id=>baccount.id)
    staffer = Factory.create(:staffer, :business_account_id=>baccount.id)
    staffer = Factory.create(:staffer, :business_account_id=>baccount.id)
    
    assert_equal 3+staffers_count, baccount.staffers.count
    
    #has to remove them all
    baccount.destroy
    assert_equal staffers_count, Staffer.count
  end


end
