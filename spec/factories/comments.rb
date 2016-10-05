FactoryGirl.define do
  factory :comment do
    body "MyComment"
    user
  end
  
  factory :invalid_comment, class: 'Comment' do
    body nil
    user
  end
end
