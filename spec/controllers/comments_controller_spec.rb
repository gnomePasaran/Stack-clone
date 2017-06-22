require "rails_helper"

shared_examples "comments" do
  describe "POST #create" do
    let(:user) { create(:user) }
    let(:post_comment) { post :create, xhr: true, params: { comment: attributes_for(:comment) }.merge(shared_context) }
    let(:post_invalid_comment) { post :create, xhr: true, params: { comment: attributes_for(:comment, :invalid) }.merge(shared_context) }

    context "as user" do
      before { sign_in user }

      it "returns http success and assigns @comment, @commentable", :aggregate_failures do
        post_comment
        expect(response).to have_http_status :created
        expect(assigns(:comment)).to eq commentable.comments.first
        expect(assigns(:commentable)).to eq commentable
      end

      it "creates comment" do
        expect { post_comment }.to change(commentable.comments, :count).by(1)
      end

      it "doesn't creates invalid comment" do
        expect { post_invalid_comment }.not_to change(commentable.comments, :count)
      end
    end

    context "as guest" do
      it "returns http unauthorized" do
        post_comment
        expect(response).to have_http_status :unauthorized
      end

      it "doesn't creates comment" do
        expect { post_comment }.not_to change(commentable.comments, :count)
      end
    end
  end
end

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }

  context "question" do
    it_behaves_like "comments" do
      let(:commentable) { question }
      let(:shared_context) { { question_id: question, commentable: "questions" } }
    end
  end

  context "answer" do
    it_behaves_like "comments" do
      let(:commentable) { create(:answer, question: question) }
      let(:shared_context) { { question_id: question, answer_id: commentable, commentable: "answers" } }
    end
  end
end
