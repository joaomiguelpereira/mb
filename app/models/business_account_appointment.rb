class BusinessAccountAppointment < ActiveRecord::Base
	belongs_to :business_account
	belongs_to :appointment
end
