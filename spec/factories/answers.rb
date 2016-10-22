FactoryGirl.define do
  sequence :body do |n|
    "Some text #{n}"
  end

  factory :answer do
    question
    user
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
