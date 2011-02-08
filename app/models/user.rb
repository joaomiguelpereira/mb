class User < ActiveRecord::Base
  #Constants for user role
  BUSINESS_OWNER = "business"
  USER = "user"
  
  attr_accessible :terms_and_conditions, :role, :email, :email_confirmation, :first_name, :last_name, :password, :password_confirmation
  
  attr_accessor  :password, :email_confirmation, :password_confirmation, :terms_and_conditions
  
  #Validations
  
  
  validates :first_name, :presence=>true, 
                         :length=>{:minimum=>2, :maximum=>64}
  
  validates :last_name, :presence=>true, 
                         :length=>{:minimum=>2, :maximum=>64}
  
  
  validates :email, :presence=>true,
                    :length=>{:minimum=>3, :maximum=>64},
                    :uniqueness=>true, 
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => I18n.t("activerecord.errors.messages.invalid_email")}
  
  
  validates :role, :presence=>true, :inclusion=>{:in=> %w(business user) }
  validates :password, :presence=>true, :on=>:create, :length=>{:minimum=>5, :maximum=>64}
  
  validates_confirmation_of :email, :password, :on=>:create
  validates_acceptance_of :terms_and_conditions, :accept => "1"
  
  #validates_format_of :email, :with => /[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]\.)[a-zA-Z]{2,4}/, 
  
  #interceptors
  before_save :encrypt_password
  before_create :generate_activation_key
  
  
  def full_name
    self.first_name+" "+self.last_name
  end
  
  def encrypt_password
    if password.present? #do it only if password is present
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def generate_activation_key
    #Generate ramdom string. See http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  
    self.activation_key =  (0..50).map{ o[rand(o.length)]  }.join;
    
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.active && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
end
