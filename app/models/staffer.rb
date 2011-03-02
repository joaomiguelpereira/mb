class Staffer < User
  belongs_to :business_account
  
  validates :business_account_id, :presence=>true
  #belongs_to :user, :as=>:account
  
end
