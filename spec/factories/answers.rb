FactoryGirl.define do
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
