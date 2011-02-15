require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  ##Associations tests
  test "can have multiple businesses" do
    previous_b_count = Business.all.count
    
    user = Factory.create(:business_admin)
    business_1 = Factory.create(:business, :business_admin_id=>user.id)
    business_2 = Factory.create(:business, :business_admin_id=>user.id)
    business_3 = Factory.create(:business, :business_admin_id=>user.id)
    
    target_user = User.find(user.id)
    assert_equal 3, target_user.businesses.count
    assert_equal (previous_b_count+3), Business.all.count
    puts "prevoiud count: "+previous_b_count.to_s
    #destroy, should destroy all businesses
    user.destroy
    puts "prevoiud count: "+previous_b_count.to_s
    assert_equal previous_b_count, Business.all.count
    puts "After the assert........."
  end
  
  test "should not save empty user" do
    user = User.new
    assert !user.save, "saved an empty user"
  end
  
  test "should not save user with empty email" do
    user = User.new
    
    user.first_name = "Jonh"
    user.last_name = "Doe"
    user.password = "somepass"
    user.password_confirmation = "somepass"
    user.terms_and_conditions = "1"
    assert !user.save, "saved an used withou email"
  end
  
  test "should create user" do
    user = User.new
    user.first_name = "Jonh"
    user.last_name = "Doe"
    user.password = "somepass"
    user.password_confirmation = "somepass"
    user.terms_and_conditions = "1"
    user.email = "jonh@doe2.com"
    user.email_confirmation = "jonh@doe2.com"
    
    
    saved = user.save
    #print "------------>"+user.errors.full_messages.to_sentence
    
    assert saved, "user not saved"
    
    saved_user = User.find_by_email("jonh@doe2.com")
    #Should be inactive
    assert !saved_user.active
    #Should have activation_key
    assert_not_nil saved_user.activation_key
    assert_not_nil saved_user, "Should have found the user"
    #puts saved_user.activation_key
  end
  
  test "should authenticate user" do
    #user = users(:jonh) 
    user = Factory.create(:user, :password=>"123456")
    assert_not_nil user
    
    #assert_equal "user", user.role
    assert_not_nil User::authenticate(user.email, "123456")
  end
  
  test "should not authenticate user wrong password" do
    #user = users(:jonh) 
    
    user = Factory.create(:user, :password=>"123456")
    assert_not_nil user
    #assert_equal "user", user.role
    assert_nil User::authenticate(user.email, "11111s")
  end
  
  test "should not authenticate inactive user" do
    user = Factory.create(:user, :active=>false, :password=>"123456")
    
    assert_not_nil user
    assert_nil User::authenticate(user.email, "123456")
  end
  
  test "should not authenticate inexisting user" do
    assert_nil User::authenticate("someduck", "2312")
  end
  
  
end
