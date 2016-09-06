FactoryGirl.define do
  factory :like, class: 'Vote' do
    user
    value 1
  end
  
  factory :dislike, class: 'Vote' do
    user
    value -1
  end
end
