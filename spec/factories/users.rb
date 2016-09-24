FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  
  sequence :name do |n|
    "user#{n}"
  end
  
  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.zone.now
  end
  
  factory :named_user, class: 'User' do
    email
    name
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.zone.now
  end
end
