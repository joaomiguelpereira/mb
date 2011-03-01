class BusinessAccount < ActiveRecord::Base
  has_many :business_admins
  has_many :staffers, :dependent=> :destroy
  
  #belongs_to :business_admin
  
  has_one :business
  
  def owner
    return BusinessAdmin.find(self.created_by_business_admin_id) if created_by_business_admin_id
  end
  
  def owner=(business_admin)
    self.created_by_business_admin_id = business_admin.id
  end
  
end
