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
    avatar File.open(Rails.root.join('app/assets/images/fallback/default-avatar.png'), 'r')
  end
  
  factory :named_user, class: 'User' do
    email
    name
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.zone.now
    avatar File.open(Rails.root.join('app/assets/images/fallback/default-avatar.png'), 'r')
  end
  
  factory :invalid_user, class: 'User' do
    name
    password '12345678'
    password_confirmation '12345678'
  end
end
