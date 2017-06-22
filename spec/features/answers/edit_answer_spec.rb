require "rails_helper"

shared_examples "unable to edit answer" do
  scenario "cannot see edit link and textarea" do
    visit question_path(not_owned_answer.question)

    within "#answer_#{not_owned_answer.id}" do
      expect(page).not_to have_selector(".edit_answer")
      expect(page).not_to have_content("Edit")
    end
  end
end

feature "edit answer" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:not_owned_answer) { create(:answer) }

  describe "guest user" do
    it_behaves_like "unable to edit answer"
  end

  describe "authenticated user" do
    background { sign_in user }

    context "owner of the answer" do
      background { visit question_path(question) }

      scenario "edits with valid attributes", :js do
        within ".answer" do
          expect(page).not_to have_selector("textarea")
          click_on "Edit"
          expect(page).not_to have_content "Edit"
          fill_in "Answer", with: "New body"
          click_on "Update answer"
          expect(page).to have_content "New body"
          expect(page).to have_content "Edit"
          expect(page).not_to have_selector("textarea")
        end
      end

      scenario "edits with invalid attributes", :js do
        within ".answer" do
          expect(page).not_to have_selector("textarea")
          click_on "Edit"
          expect(page).not_to have_content "Edit"
          fill_in "Answer", with: ""
          click_on "Update answer"
          expect(page).to have_content "Body can't be blank"
          expect(page).not_to have_content "Edit"
          expect(page).to have_selector("textarea")
        end
      end
    end

    context "not owner of the answer" do
      it_behaves_like "unable to edit answer"
    end
  end
end
