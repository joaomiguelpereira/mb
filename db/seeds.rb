# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

owner = Factory.create(:business_admin, :email=>"joaomiguel.pereira@gmail.com", :password=>"12345")
account = Factory.create(:business_account, :owner=>owner)
owner.business_account = account
owner.save!
#Factory.create(:business,:business_admin_id=>owner.id)
#Factory.create(:business,:business_admin_id=>owner.id)
#Factory.create(:business,:business_admin_id=>owner.id)
#Factory.create(:business,:business_admin_id=>owner.id)
#Factory.create(:business,:business_admin_id=>owner.id)
#Factory.create(:business,:business_admin_id=>owner.id)

owner = Factory.create(:business_admin, :email=>"cmsrodrigues@gmail.com", :password=>"12345")
account = Factory.create(:business_account, :owner=>owner)
owner.business_account = account
owner.save!
