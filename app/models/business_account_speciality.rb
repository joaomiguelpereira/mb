class BusinessAccountSpeciality < ActiveRecord::Base
  belongs_to :business_account
  belongs_to :speciality
end
