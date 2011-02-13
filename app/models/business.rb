class Business < ActiveRecord::Base
  belongs_to :user
  attr_accessible :terms_and_conditions, :short_name, :full_name, :description, 
                  :address, :city, :postal_code, :url,
                  :twitter, :facebook, :fax, :phone, :email
                   
  attr_accessor :terms_and_conditions
  
  #short name identifies the business across all the system and can only have letters and number
  #and must be unique
  validates :user_id, :presence=>true
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
  validates :postal_code, :presence=>true, 
                   :length=>{:minimum=>8, :maximum=>120}
  validates :terms_and_conditions, :acceptance=>true
  validates :url, 
            :format=>/(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$)|(^$)/ix

  validates :twitter, 
            :format=>/(^(http|https):\/\/twitter.com\/[a-z0-9])|(^$)/ix
  validates :facebook, 
            :format=>/(^(http|https):\/\/facebook.com\/[a-z0-9])|(^$)/ix

  validates :email, :format => {:with => /(^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i, :message => I18n.t("activerecord.errors.messages.invalid_email")}
end
