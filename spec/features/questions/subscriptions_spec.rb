require "rails_helper"

feature "subscriptions on question updates", :users do
  given(:question) { create(:question) }

  context "as user", :js, :auth do
    scenario "can subscribe" do
      visit question_path(question)
      click_on "Notify on updates for this question"
      expect(page).to have_content "Do not notify"
      expect(page).not_to have_content "Notify on updates for this question"
    end

    scenario "can unsubscribe" do
      create(:subscription, user: user, question: question)
      visit question_path(question)
      click_on "Do not notify"
      expect(page).not_to have_content "Do not notify"
      expect(page).to have_content "Notify on updates for this question"
    end
  end

  context "as question author", :js, :auth do
    given!(:question) { create(:question, user: user) }
    scenario "can unsubscribe" do
      visit question_path(question)
      click_on "Do not notify"
      expect(page).not_to have_content "Do not notify"
      expect(page).to have_content "Notify on updates for this question"
    end
  end

  context "as guest" do
    scenario "can not subscribe or unsubscribe" do
      visit question_path(question)
      expect(page).not_to have_content "Notify on updates for this question"
      expect(page).not_to have_content "Do not notify"
    end
  end
end
