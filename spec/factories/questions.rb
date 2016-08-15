FactoryGirl.define do
  sequence :title do |n|
    "Some title #{n}"
  end

  factory :question do
    user
    title
    body 'MyText'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
