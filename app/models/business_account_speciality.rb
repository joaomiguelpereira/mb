class BusinessAccountSpeciality < ActiveRecord::Base
  belongs_to :business_account
  belongs_to :speciality
  
  after_create :build_default_json_data
  
  
  private 
  def build_default_json_data
    
  end
end
