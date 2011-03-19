require 'test_helper'

class BusinessAccountTest < ActiveSupport::TestCase
  
  setup do
    @badmin = Factory.create(:business_admin)
    @baccount = Factory.create(:business_account, :owner=>@badmin)
    business = Factory.create(:business)
    @baccount.business = business
    @baccount.save
  end
  
  test "availability should be destroyed on business detroy" do

    account  = BusinessAccount.find(@baccount.id)
    
    assert_not_nil account.availability
    account_id = account;
    availability_id = account.availability.id
    account.destroy
    assert_nil BusinessAccount.find_by_id(account_id)
    assert_nil Availability.find_by_id(availability_id)
    
    
  end
  test "business account have an default availability" do

    account  = BusinessAccount.find(@baccount.id)
    
    assert_not_nil account.availability
    assert_not_nil account.availability.json_data
    assert_not_nil account.availability.exceptions_json_data
    #mimic default json_data
    
    def_json_data = Array.new
    for i in (0..6)
      day_array = Array.new
      def_json_data << day_array
    end
    
    
    assert_equal account.availability.exceptions_json_data, Array.new.to_json
    assert_equal account.availability.json_data, def_json_data.to_json
      
  end
  
  test "business account have have many specialities" do
    spec1 = Factory.create(:speciality)
    spec2 = Factory.create(:speciality)
    assert_equal 0, @baccount.specialities.count 
    @baccount.specialities << spec1
    #get from db
    bacc = BusinessAccount.find(@baccount.id)
    
    assert_equal 1, bacc.specialities.count
    
    @baccount.specialities << spec2
    #get from db
    bacc = BusinessAccount.find(@baccount.id)
    
    assert_equal 2, bacc.specialities.count
  end
  
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
