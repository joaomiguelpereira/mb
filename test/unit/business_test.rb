require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Should create business" do
    business = Business.new
    
    bowner = users(:bowner)
    
    business.short_name ="ClinicA"
    business.full_name ="A clinica da beatriz, unhas e manicure"
    business.description ="Alguma descritpion aqui"
    business.address ="Address"
    business.email ="some@email.com"
    business.phone ="12345678"
    business.fax ="1234567" 
    business.url ="http://test.com"
    business.facebook ="http://facebook.com"
    business.twitter ="http://twitter.com"
    business.user = bowner
    
    assert business.save, "Business not saved"
    updated_user = User.find(bowner)
    assert_equal 1, updated_user.businesses.count 
  end
  
  test "should not create withou required fiels" do
    business =  Factory.build(:business, :short_name=>"")
    
    
    bowner = users(:bowner)
    
    
    assert !business.save, "Business  saved without required fields"
    
     
    
  end
end
