require 'test_helper'

class BusinessAccountAppointmentTest < ActiveSupport::TestCase

	setup do
		@badmin = Factory.create(:business_admin)
		@baccount = Factory.create(:business_account, :owner=>@badmin)
		@badmin.business_account = @baccount
		@badmin.save
		
		@user = Factory.create(:user)
	end
	test "a business account can have multiple appoitments" do
		Appointment.delete_all
		BusinessAccountAppointment.delete_all
		#create an appointment for a user
		app1 = Factory.create(:appointment)
		assert_equal 0, @user.appointments.count
		assert_equal 0, @baccount.appointments.count
		
		@user.appointments<<app1
		@user.save
		@baccount.appointments << app1
		@baccount.save
		assert_equal 1, @user.appointments.count
		assert_equal 1, @baccount.appointments.count
	end
	
	test "delete appoitments association if business destroyed" do
		Appointment.delete_all
		BusinessAccountAppointment.delete_all
		#create an appointment for a user
		app1 = Factory.create(:appointment)
		assert_equal 0, @user.appointments.count
		assert_equal 0, @baccount.appointments.count
		
		@user.appointments<<app1
		@user.save
		@baccount.appointments << app1
		@baccount.save
		assert_equal 1, @user.appointments.count
		assert_equal 1, @baccount.appointments.count
		assert_equal 1, BusinessAccountAppointment.count
		@baccount.destroy
		assert_equal 0, BusinessAccountAppointment.count
	end
end
