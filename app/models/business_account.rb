class BusinessAccount < ActiveRecord::Base
  has_many :business_admins
  has_many :staffers, :dependent=> :destroy
  has_many :business_account_specialities
  has_many :specialities, :through=>:business_account_specialities
  
  #belongs_to :business_admin
  
  has_one :business
  
#  def specialities
#    self.business_account_specialities
#  end
#  
#  def add_speciality(speciality)
#    #chek if it have it already
#    test_speciality =  Speciality.
#    self.business_account_specialities << speciality 
#  end
#  
  def owner
    return BusinessAdmin.find(self.created_by_business_admin_id) if created_by_business_admin_id
  end
  
  def owner=(business_admin)
    self.created_by_business_admin_id = business_admin.id
  end
  
end
