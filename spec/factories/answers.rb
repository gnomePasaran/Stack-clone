FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer body #{n}" }
    question
    user

    factory :invalid_answer do
      body nil
      question nil
      user nil
    end
  end
end
