class StafferSpeciality < ActiveRecord::Base
	belongs_to :staffer
	belongs_to :speciality
end
