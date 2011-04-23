class CreateStafferSpecialities < ActiveRecord::Migration
	def self.up
		create_table :staffer_specialities do |t|
			t.integer :staffer_id
			t.integer :speciality_id

			t.timestamps
		end
	end

	def self.down
		drop_table :staffer_specialities
	end
end

