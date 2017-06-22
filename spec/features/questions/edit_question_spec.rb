require "rails_helper"

shared_examples "unable to edit question" do
  scenario "cannot see edit link and textarea" do
    visit question_path(not_owned_question)

    within "#question_#{not_owned_question.id}" do
      expect(page).not_to have_selector("textarea")
      expect(page).not_to have_content("Edit")
    end
  end
end

feature "edit question" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:not_owned_question) { create(:question) }

  describe "guest user" do
    it_behaves_like "unable to edit question"
  end

  describe "authenticated user" do
    background { sign_in user }

    context "owner of the question" do
      background { visit question_path(question) }

      scenario "edits with valid attributes", :js do
        within ".question" do
          expect(page).not_to have_selector("textarea")
          click_on "Edit"
          expect(page).not_to have_content "Edit"
          fill_in "Title", with: "New title"
          fill_in "Body", with: "New body"
          click_on "Update Question"
          expect(page).to have_content "New title"
          expect(page).to have_content "New body"
          expect(page).to have_content "Edit"
          expect(page).not_to have_selector("textarea")
        end
      end

      scenario "edits with invalid attributes", :js do
        within ".question" do
          expect(page).not_to have_selector("textarea")
          click_on "Edit"
          expect(page).not_to have_content "Edit"
          fill_in "Title", with: ""
          fill_in "Body", with: ""
          click_on "Update Question"
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
          expect(page).not_to have_content "Edit"
          expect(page).to have_selector("textarea")
        end
      end
    end

    context "not owner of the question" do
      it_behaves_like "unable to edit question"
    end
  end
end
