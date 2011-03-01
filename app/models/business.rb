class Business < ActiveRecord::Base
  
  #belongs_to :business_account
  
  before_save :fix_short_name
  attr_accessible :terms_and_conditions, :full_name, :description, 
                  :address, :city, :postal_code, :url,
                  :twitter, :facebook, :fax, :phone, :email
  
  attr_accessor :terms_and_conditions
  
  #short name identifies the business across all the system and can only have letters and number
  #and must be unique
  #validates :business_account_id, :presence=>true
  
  validates :short_name, :presence=>true, 
                         :length=>{:minimum=>4, :maximum=>24},
                         :uniqueness=>true,
                         :format=>/^[A-Za-z\d_]+$/
  
  validates :full_name, :presence=>true,
                        :length=>{:minimum=>4, :maximum=>120}
  validates :description, :presence=>true,
                        :length=>{:minimum=>20, :maximum=>320}
  validates :address, :presence=>true,
                      :length=>{:minimum=>5, :maximum=>120}
  
  validates :city, :presence=>true,
                   :length=>{:minimum=>2, :maximum=>120}
  validates :postal_code, :presence=>true, :postal_code=>true
  validates :phone, :phone=>true
  validates :fax, :phone=>true
  
  
  validates :terms_and_conditions, :acceptance=>true
  validates :url, 
            :format=>/(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$)|(^$)/ix
  
  validates :twitter, 
            :format=>/(^(http|https):\/\/twitter.com\/[a-z0-9])|(^$)/ix
  validates :facebook, 
            :format=>/(^(http|https):\/\/facebook.com\/[a-z0-9])|(^$)/ix
  
  validates :email, :format => {:with => /(^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i, :message => I18n.t("activerecord.errors.messages.invalid_email")}
  
  def fix_short_name
    self.short_name = self.short_name.downcase
  end
  
  private
  def mass_assignment_authorizer
    super  + ( new_record? ? [:short_name]: [])
  end
  
end
