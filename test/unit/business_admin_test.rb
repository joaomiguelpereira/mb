require 'test_helper'

class BusinessAdminTest < ActiveSupport::TestCase
    
   test "business admin can own one business account" do

     #create the business admin
     business_admin = Factory.create(:business_admin)
     
     #create a business account for the business admin
     business_account = Factory.create(:business_account, :owner=>business_admin) 
     
     business_admin.business_account = business_account 
     assert business_admin.save!, "Should have been saved"
     
     baccount = BusinessAccount.find(business_account.id)
     
     assert_equal baccount.owner.id, business_admin.id
     
     assert_equal 1, baccount.business_admins.count
   end
 
   test "business account can have multiple business admins" do
     business_admin = Factory.create(:business_admin)  
     #create a business account for the business admin
     business_account = Factory.create(:business_account, :owner=>business_admin) 
     
     business_admin.business_account = business_account 
     assert business_admin.save!, "Shoudl been saved"
     
     #create othewr badmin
     business_admin_2 = Factory.create(:business_admin)
     business_admin_2.business_account = business_account
     assert business_admin_2.save!, "Shoudl been saved"
     
     baccount = BusinessAccount.find(business_account.id)
     assert_equal 2, baccount.business_admins.count
 end
 
 
end
