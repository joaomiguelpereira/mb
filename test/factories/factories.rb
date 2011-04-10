Factory.define :availability do |f| 
 
end

Factory.define :speciality do |f|
  f.sequence(:name) {StringUtils.generate_random_string(10)}
  f.description {StringUtils.generate_random_string(10)}
end

Factory.define :user do |f|
  f.sequence(:email) {"user#{(rand*Time.now.to_f).to_i}@mail.com"}
  f.password "12345"
  f.first_name "Jonh"
  f.last_name "Doe"
  f.active true
  f.activation_key nil
  f.reset_password_key nil
end
Factory.define :business_account do |f|
  f.owner nil
  
end

Factory.define :business do |f|
  f.sequence(:short_name) {"business#{(rand*Time.now.to_f).to_i}"}
  f.full_name "A clinica da beatriz, unhas e manicure"
  f.description "Alguma descritpion aqui"
  f.address "Address"
  f.email "some@email.com"
  f.phone "123456789"
  f.fax "123456789" 
  f.url "http://test.com"
  f.facebook "http://facebook.com/test"
  f.twitter "http://twitter.com/test"
  f.city "Aveiro"
  f.postal_code "3452-202"
  #f.business_account_id nil
end

Factory.define :business_admin do |f|
  f.sequence(:email) {"badmin#{(rand*Time.now.to_f).to_i}@mail.com"}
  f.password "12345"
  f.first_name "Jonh"
  f.last_name "Doe"
  f.active true
  f.business_account_id nil
  f.notify_on_create false
  #f.business_id nil
end

Factory.define :staffer do |f|
  f.sequence(:email) {"staffer#{(rand*Time.now.to_f).to_i}@mail.com"}
  f.password "12345"
  f.first_name "Jonh"
  f.last_name "Doe"
  f.active true
  f.notify_on_create false
  f.business_account_id nil
  f.need_new_password false
end
#
#Factory.define :worker do |f|
#  f.sequence(:name) {|n| "Worker#{n} name "}
#  f.sequence(:email) {|n| "worker#{n}@mail.com"}
#  f.address "worker address, Street of nowhere"
#  f.city "city of angels"
#  f.postal_code "34545262626"
#  f.phone "123456789"
#  f.user_id  nil
#end
