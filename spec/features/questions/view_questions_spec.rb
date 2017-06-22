require "rails_helper"

feature "view questions" do
  given(:question) { create(:question) }

  scenario "user views questions" do
    question
    visit root_path
    expect(page).to have_content question.title
  end

  scenario "user can view question and answers" do
    answer = create(:answer, question: question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
