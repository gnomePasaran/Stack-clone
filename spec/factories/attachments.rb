FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") }
    factory :question_attachment do
      association :attachable, factory: :question
    end
    factory :answer_attachment do
      association :attachable, factory: :answer
    end
  end
end
