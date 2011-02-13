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
    business.city= "Aveiro"
    business.postal_code = "1234567890"
    business.url ="http://test.com"
    business.facebook ="http://facebook.com/test"
    business.twitter ="http://twitter.com/test"
    business.user = bowner
    saved = business.save
    #puts "error: "+business.errors.full_messages.to_sentence
    assert saved, "Business not saved"
    updated_user = User.find(bowner)
    assert_equal 1, updated_user.businesses.count 
  end
  
  test "should fix short name" do
    business =  Factory.build(:business, :short_name=>"A_clinica_Das_s123d")
    bowner = users(:bowner)
    business.user_id = bowner
    saved = business.save
    #puts "error: "+business.errors.full_messages.to_sentence
    assert saved, "Business should have been saved"
    assert_equal "a_clinica_das_s123d", business.short_name
  end
  test "should not create withou required fiels" do
    business =  Factory.build(:business, :short_name=>"")
    
    
    bowner = users(:bowner)
    
    
    assert !business.save, "Business  saved without required fields"
    
     
    
  end
end
