require "rails_helper"

shared_examples "sees question form" do
  click_on "Ask Question"
  expect(page).to have_content "Create Question"
end

feature "create question" do
  given(:user) { create(:user) }

  describe "authenticated user" do
    background do
      sign_in user
      visit new_question_path
    end

    it "sees question form" do
      expect(page).to have_button "Create Question"
    end

    scenario "creates question with valid attributes" do
      fill_in "Title", with: "How much is the fish?"
      fill_in "Body", with: "Can't find price"
      click_on "Create Question"
      within ".question" do
        expect(page).to have_content "How much is the fish?"
        expect(page).to have_content "Can't find price"
      end
    end

    scenario "cannot create question with invalid attributes" do
      click_on "Create Question"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    xscenario "adds file" do
      fill_in "Title", with: "How much is the fish?"
      fill_in "Body", with: "Can't find price"
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
      click_on "Create Question"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    end

    xscenario "adds files via cocoon", :js do
      fill_in "Title", with: "How much is the fish?"
      fill_in "Body", with: "Can't find price"
      click_on "add file"
      within ".nested-fields:nth-child(2)" do
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on "add file"
      within ".nested-fields:nth-child(3)" do
        attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on "Create Question"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    end
  end

  describe "guest user" do
    scenario "creates question" do
      visit root_path
      click_on "Ask Question"
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
