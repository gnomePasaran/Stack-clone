require "rails_helper"

feature "answer on question" do
  given!(:question) { create(:question) }

  describe "authenticated user", :js do
    given(:user) { create(:user) }

    background do
      sign_in user
      visit question_path(question)
    end

    # Disabled until ActionCable fix
    xscenario "can answer on question with valid attributes" do
      fill_in "Answer", with: "Dunno"
      click_on "Submit answer"
      within ".answers" do
        expect(page).to have_content "Dunno"
      end
      expect(find_field("Answer").value).to be_empty
    end

    scenario "cannot answer on question with invalid attributes" do
      click_on "Submit answer"
      within ".answer_errors" do
        expect(page).to have_content "Body can't be blank"
      end
    end

    # Re-enable when remotipart will be ready for rails 5
    xscenario "answer with file" do
      fill_in "Answer", with: "Dunno"
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
      click_on "Submit answer"
      within ".answers" do
        expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      end
    end

    xscenario "adds files via cocoon", :js do
      fill_in "Answer", with: "Dunno"
      click_on "add file"
      within all(".nested-fields").last do
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on "add file"
      within all(".nested-fields").last do
        attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on "Submit answer"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    end
  end

  scenario "Guest user cannot answer on question" do
    visit root_path
    click_on question.title
    expect(page).to have_content "Please sign in to answer the question."
  end
end
