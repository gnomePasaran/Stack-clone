require "rails_helper"

shared_examples "comments feature" do
  context "as user", :js do
    background do
      sign_in question.user
      visit question_path(question)
    end

    it_behaves_like "views comments"

    # Disabled until fix ActionCable response
    xscenario "create comment" do
      within commentable_selector do
        click_on "add a comment"
        expect(page).not_to have_content "add a comment"

        fill_in "Comment", with: "New comment"
        click_on "Add Comment"

        within ".comments" do
          expect(page).to have_content "New comment"
        end

        expect(page).not_to have_button "Add Comment"
        expect(page).to have_content "add a comment"
        expect(page).not_to have_selector("textarea")
        expect(find_field("Comment", visible: false).value).to be_empty
      end
    end

    scenario "can't create invalid comment" do
      within commentable_selector do
        click_on "add a comment"
        click_on "Add Comment"

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_button "Add Comment"
        expect(page).not_to have_content "add a comment"
        expect(page).to have_selector("textarea")
      end
    end
  end

  context "as guest" do
    it_behaves_like "views comments"

    scenario "can't see add a comment link" do
      visit question_path(question)
      expect(page).not_to have_content "add a comment"
    end
  end
end

shared_examples "views comments" do
  scenario "views comment" do
    comment = create(:comment, commentable: commentable)
    visit question_path(question)
    expect(page).to have_content comment.body
  end
end

feature "comment answer" do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:commentable) { answer }
  given(:commentable_selector) { ".answer" }

  it_behaves_like "comments feature"
end

feature "comment question" do
  given(:question) { create(:question) }
  given(:commentable) { question }
  given(:commentable_selector) { ".question" }

  it_behaves_like "comments feature"
end
