FactoryGirl.define do
  factory :twitter_authorization, class: 'Authorization' do
    user
    provider "twitter"
    uid "12345"
  end
end
