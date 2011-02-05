class User < ActiveRecord::Base
  #Constants for user role
  BUSINESS_OWNER = "business"
  USER = "user"
  
  attr_accessible :role, :email, :email_confirmation, :firt_name, :last_name, :password, :password_confirmation
  
  attr_accessor :password
  attr_accessor :email_confirmation, :password_confirmation
  
end
