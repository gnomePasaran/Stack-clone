FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    sequence(:body) { |n| "Good question body #{n}" }
    user

    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
