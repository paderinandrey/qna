FactoryGirl.define do
    sequence(:id) { |n| n }

    sequence :body do |n|
    "Some text #{n}"
  end
end
