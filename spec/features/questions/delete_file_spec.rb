require "rails_helper"

feature "delete file" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  before do
    create(:question_attachment, attachable: question)
    sign_in user
    visit question_path(question)
  end

  scenario "delete file", :js do
    expect(page).to have_link "spec_helper.rb"
    click_on "Edit"
    click_on "remove file"
    click_on "Update Question"
    expect(page).not_to have_link "spec_helper.rb"
  end
end
