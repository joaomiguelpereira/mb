class User < ActiveRecord::Base

  
  attr_accessible :phone, :address, :postal_code, :city, :terms_and_conditions, 
                  :email_confirmation, :first_name, :last_name, 
                  :password, :password_confirmation
  
  attr_accessor  :password, :email_confirmation, :password_confirmation, :terms_and_conditions, :updating_password 
  #Validations
  validates :postal_code, :postal_code=>true
  validates :phone, :phone=>true
  
  
  validates :first_name, :presence=>true, 
                         :length=>{:minimum=>2, :maximum=>64}
  
  validates :last_name, :presence=>true, 
                         :length=>{:minimum=>2, :maximum=>64}
  
  
  validates :email, :presence=>true,
                    :length=>{:minimum=>3, :maximum=>64},
                    :uniqueness=>true, 
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => I18n.t("activerecord.errors.messages.invalid_email")}
  
  
  validates :password, :presence=>true, :length=>{:minimum=>5, :maximum=>64}, :if=>:validate_password?
  
  validates_confirmation_of :password, :if=>:validate_password?
  
  validates_confirmation_of :email, :on=>:create
  
  validates_acceptance_of :terms_and_conditions, :accept => "1"
  
  #validates_format_of :email, :with => /[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]\.)[a-zA-Z]{2,4}/, 
  
  #interceptors
  before_save :encrypt_password
  before_create :generate_activation_key
  
  
  def validate_password?
    updating_password || new_record?  
  end
  
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
    #Generate random string. See http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
    #o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  
    #self.activation_key =  (0..50).map{ o[rand(o.length)]  }.join;
    self.activation_key = StringUtils::generate_random_string
  end
  
  def self.authenticate_from_salt(user_id, salt) 
    user = nil 
    if (!user_id.nil? && !salt.nil?)
      user = find_by_id_and_password_salt(user_id, salt)
    end
    
    if user && user.active
      user
    else
      nil
    end
    
    
  end
  def staffer?
    (type.nil?) || (type == Staffer.name) ? true : false
  end
  
  def user?
    (type.nil?) || (type == User.name) ? true : false
  end
  
  def business_admin?
    (!type.nil?) && (type == BusinessAdmin.name) ? true : false
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.active && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  private
  def mass_assignment_authorizer
    super  + ( new_record? ? [:email]: [])
  end
end
