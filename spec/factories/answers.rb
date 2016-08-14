FactoryGirl.define do
  sequence :body do |n|
    "Some text #{n}"
  end

  factory :answer do
    id
    question
    user
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
