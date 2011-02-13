
Factory.define :user do |f|
  f.sequence(:email) {|n| "user#{n}@mail.com"}
  f.password "12345"
  f.first_name "Jonh"
  f.last_name "Doe"
  f.role {User::USER}
  f.active true
end

Factory.define :business do |f|
  f.sequence(:short_name) {|n| "business#{n}"}
  f.full_name "A clinica da beatriz, unhas e manicure"
  f.description "Alguma descritpion aqui"
  f.address "Address"
  f.email "some@email.com"
  f.phone "12345678"
  f.fax "1234567" 
  f.url "http://test.com"
  f.facebook "http://facebook.com/test"
  f.twitter "http://twitter.com/test"
  f.city "Aveiro"
  f.postal_code "3452-202 aveiro"
  f.user_id nil
end

