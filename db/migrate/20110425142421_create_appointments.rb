class CreateAppointments < ActiveRecord::Migration
	def self.up
		create_table :appointments do |t|
			t.integer :user_id
			t.datetime :start_date
			t.integer :duration
			t.text :notes 
			t.timestamps
		end
	end

	def self.down
		drop_table :appointments
	end
end
