class Staffer < User
	belongs_to :business_account
	#has_one :availability, :dependent=> :destroy
	has_one :availability, :dependent=> :destroy, :as=>:availabilityable
	validates :business_account_id, :presence=>true
	#belongs_to :user, :as=>:account

	after_create :create_default_availability
	
	private
	def create_default_availability
		if self.availability.nil?
			self.availability = Availability.new
			#self.availability.json_data = ""
			#self.availability. exceptions_json_data = Array.new.to_json
			self.save
		end
	end
end
