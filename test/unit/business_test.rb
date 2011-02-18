require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Should create business" do
    business = Business.new
   
    bowner = Factory.create(:business_admin)
    
    business.short_name ="ClinicA"
    business.full_name ="A clinica da beatriz, unhas e manicure"
    business.description ="Alguma descritpion aqui"
    business.address ="Address"
    business.email ="some@email.com"
    business.phone ="123456789"
    business.fax ="123456789" 
    business.city= "Aveiro"
    business.postal_code = "1234-321"
    business.url ="http://test.com"
    business.facebook ="http://facebook.com/test"
    business.twitter ="http://twitter.com/test"
    business.business_admin = bowner
    
    saved = business.save
    puts "error: "+business.errors.full_messages.to_sentence
    assert saved, "Business not saved"
    updated_user = BusinessAdmin.find(bowner)
    assert_equal 1, updated_user.businesses.count 
  end
  
  test "should fix short name" do
    business =  Factory.build(:business, :short_name=>"A_clinica_Das_s123d")
    bowner = Factory.create(:business_admin)
    
    business.business_admin = bowner
    saved = business.save
    #puts "error: "+business.errors.full_messages.to_sentence
    assert saved, "Business should have been saved"
    assert_equal "a_clinica_das_s123d", business.short_name
  end
  test "should not create withou required fiels" do
    bowner = Factory.create(:business_admin)
    business =  Factory.build(:business, :short_name=>"", :business_admin_id=>bowner.id)
    
    
   
    
    
    #assert !business.save, "Business  saved without required fields"
    
     
    
  end
end
