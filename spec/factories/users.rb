FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password "12345678"
    confirmed_at Time.zone.now
  end
end
