class BusinessAccount < ActiveRecord::Base
  has_many :business_admins
  has_many :staffers, :dependent=> :destroy
  has_one :availability, :dependent=> :destroy
  has_many :business_account_specialities, :dependent=> :destroy
  has_many :specialities, :through=>:business_account_specialities
  
  after_create :create_default_availability
  
  has_one :business
   
  def owner
    return BusinessAdmin.find(self.created_by_business_admin_id) if created_by_business_admin_id
  end
  
  
  
  def owner=(business_admin)
    self.created_by_business_admin_id = business_admin.id
  end
  
  private 
  def create_default_availability
    if self.availability.nil?
      self.availability = Availability.new
      self.availability.json_data = ""
      self.availability.exception_json_data = ""
      
      self.save
    end
  end
  
end
