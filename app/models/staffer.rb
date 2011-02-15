class Staffer < User
  belongs_to :business_admin
  
  validates :business_admin_id, :presence=>true
  #belongs_to :user, :as=>:account
  
end
