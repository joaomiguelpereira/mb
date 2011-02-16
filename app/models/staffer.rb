class Staffer < User
  belongs_to :business_admin
  attr_accessible :notify_on_create
  attr_accessor :notify_on_create
  
  
  
  validates :business_admin_id, :presence=>true
  #belongs_to :user, :as=>:account
  
end
