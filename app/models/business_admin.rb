class BusinessAdmin < User
  belongs_to :business_account
  
  
  def business
    self.business_account.business
  end
end
