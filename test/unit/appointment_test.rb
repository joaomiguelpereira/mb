require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase

	setup do
		
		
		
	end

	test "User can have multiple appointmens" do
		user = Factory.create(:user)
		assert_equal 0, user.appointments.count
		#Create new appoitment
		app1 = Factory.create(:appointment)
		app2 = Factory.create(:appointment)
		user.appointments << app1
		user.appointments << app2
		
		user.save
		
		user = User.find(user.id)
		assert_equal 2, user.appointments.count
		
	end
	
	test "appoitments are deleted when user is deleted" do
		#clear appoitments table
		Appointment.delete_all
		user = Factory.create(:user)
		
		#Create new appoitment
		app1 = Factory.create(:appointment)
		app2 = Factory.create(:appointment)
		user.appointments << app1
		user.appointments << app2
		
		user.save
		
		
		assert_equal 2, Appointment.count
		#delete user
		user.destroy
		assert_equal 0, Appointment.count
		
		
	end
end
