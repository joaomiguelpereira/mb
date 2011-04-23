require 'test_helper'

class StafferTest < ActiveSupport::TestCase

	setup do
		@badmin = Factory.create(:business_admin)
		@baccount = Factory.create(:business_account, :owner=>@badmin)
		business = Factory.create(:business)
		@baccount.business = business
		@baccount.save
		@staffer = Factory.create(:staffer, :business_account=>@baccount)
	end

	test "staffer can have have many specialities" do
		spec1 = Factory.create(:speciality)
		spec2 = Factory.create(:speciality)
		assert_equal 0, @baccount.specialities.count
		@staffer.specialities << spec1
		#get from db
		staffer = Staffer.find(@staffer.id)

		assert_equal 1, staffer.specialities.count

		@staffer.specialities << spec2
		#get from db
		staffer = Staffer.find(@staffer.id)

		assert_equal 2, staffer.specialities.count
	end

	test "staffer have an default availability" do

	#create a staffer
		staffer = Factory.create(:staffer, :business_account=>@baccount)

		assert_not_nil staffer.availability
		assert_not_nil staffer.availability.json_data
		assert_not_nil staffer.availability.exceptions_json_data
		#mimic default json_data

		def_json_data = Array.new
		for i in (0..6)
			day_array = Array.new
			def_json_data << day_array
		end

		assert_equal Array.new.to_json, staffer.availability.exceptions_json_data
		assert_equal staffer.availability.json_data, def_json_data.to_json

	end
end
