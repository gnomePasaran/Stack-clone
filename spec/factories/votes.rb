FactoryGirl.define do
  factory :vote do
    user
    score 1
    factory :question_vote do
      association :votable, factory: :question
    end
    factory :answer_vote do
      association :votable, factory: :answer
    end
  end
end
