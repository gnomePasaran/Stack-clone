require "rails_helper"

shared_examples "cannot delete answer or file" do
  scenario "cannot delete answer or file" do
    visit question_path(not_owned_answer.question)
    within ".answer#answer_#{not_owned_answer.id}" do
      expect(page).not_to have_link "Delete"
    end
    expect(page).not_to have_link "remove file"
  end
end

feature "delete answer" do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:not_owned_answer) { create(:answer) }
  given!(:question) { create(:question) }

  context "user access" do
    background { sign_in user }

    scenario "own answer", :js do
      visit question_path(answer.question)
      within ".answer#answer_#{answer.id}" do
        click_on "Delete"
      end
      expect(page).not_to have_css ".answer#answer_#{answer.id}"
    end

    # Disabled until ActionCable fix
    xscenario "create and delete answer", :js do
      visit question_path(question)
      fill_in "Answer", with: "Check ajax event reloaded"
      click_on "Submit answer"
      within ".answer" do
        click_on "Delete"
      end
      expect(page).not_to have_css ".answer"
    end

    xscenario "delete file", :js do
      create(:answer_attachment, attachable: answer)
      visit question_path(answer.question)
      expect(page).to have_link "spec_helper.rb"
      click_on "Edit"
      click_on "remove file"
      click_on "Update answer"
      expect(page).not_to have_link "spec_helper.rb"
    end

    describe "not own answer" do
      it_behaves_like "cannot delete answer or file"
    end
  end

  context "guest access" do
    it_behaves_like "cannot delete answer or file"
  end
end
