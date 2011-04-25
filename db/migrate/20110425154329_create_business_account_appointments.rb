class CreateBusinessAccountAppointments < ActiveRecord::Migration
	def self.up
		create_table :business_account_appointments do |t|
			t.integer :appointment_id
			t.integer :business_account_id
			t.timestamps
		end
	end

	def self.down
		drop_table :business_account_appointments
	end
end
