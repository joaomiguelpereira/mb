require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
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
    user.role = User::USER
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
    user.role = "business"
    
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
    user = users(:jonh) 
    assert_not_nil user
    assert_equal "user", user.role
    assert_not_nil User::authenticate(user.email, "11111")
  end
  
  test "should not authenticate user wrong password" do
    user = users(:jonh) 
    assert_not_nil user
    assert_equal "user", user.role
    assert_nil User::authenticate(user.email, "11111s")
  end
  
  test "should not authenticate inactive user" do
    user = users(:not_active) 
    assert_not_nil user
    assert_equal "user", user.role
    assert_nil User::authenticate(user.email, "11111")
  end
  
  test "should not authenticate inexisting user" do
    assert_nil User::authenticate("someduck", "2312")
  end
  
  
end
