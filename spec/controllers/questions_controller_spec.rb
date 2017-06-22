require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:owned_question) { create(:question, user: user) }

  # DHH on testing templates and vars in controller
  # https://github.com/rails/rails/issues/18950

  shared_examples "public access" do
    describe 'GET #index' do
      before { get :index }

      it "assigns questions to @questions" do
        questions = create_pair(:question)
        expect(assigns(:questions)).to match_array(questions)
      end

      it "renders index template" do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      it "shows first in list if accepted" do
        question = create(:question)
        answer = create(:answer, question: question)
        accepted_answer = create(:answer, question: question, accepted: true)

        get :show, params: { id: question }
        expect(question.answers).to eq([accepted_answer, answer])
      end
    end
  end

  it_behaves_like "votable" do
    let(:votable) { question }
    let(:owned_votable) { owned_question }
    let(:shared_context) { { id: question } }
  end

  describe "guest user" do
    it_behaves_like "public access"

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it "assigns question to @question" do
        expect(assigns(:question)).to eq(question)
      end

      it "renders show template" do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      it "redirects to user login form" do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'PATCH #update' do
      it "responses with 401" do
        patch :update, xhr: true, params: { id: question }
        expect(response.status).to eq 401
      end
    end

    describe 'POST #create' do
      it "redirects to user login form" do
        post :create
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it "redirects to user login form" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "authenticated user" do
    before { sign_in user }

    it_behaves_like "public access"

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it "assigns question to @question" do
        expect(assigns(:question)).to eq(question)
      end

      it "assigns answer to @answer" do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "renders show template" do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it "assigns new question to @question" do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        let(:post_question) { post :create, params: { question: attributes_for(:question) } }

        it "creates new question in the database" do
          expect { post_question }.to change(user.questions, :count).by(1)
        end

        it "creates subscription" do
          expect { post_question }.to change(Subscription, :count).by(1)
        end

        it "redirects to @question" do
          post_question
          expect(response).to redirect_to assigns(:question)
        end
      end

      context "with invalid attributes" do
        let(:post_invalid_question) { post :create, params: { question: attributes_for(:invalid_question) } }
        it "doesn't create new question in the database" do
          expect { post_invalid_question }.not_to change(Question, :count)
        end

        it "renders new template" do
          post_invalid_question
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      it_behaves_like "delete attachment" do
        let(:attachable) { question }
        let(:owned_attachable) { owned_question }
        let(:context_params) { {} }
      end

      context "owner of the question" do
        context "with valid attributes" do
          it "renders update template" do
            patch :update, xhr: true, params: { id: owned_question, question: attributes_for(:question) }
            expect(response).to render_template :update
          end

          it "updates question" do
            patch :update, xhr: true, params: { id: owned_question, question: { title: "New title", body: "New body" } }
            owned_question.reload
            expect(owned_question.title).to eq "New title"
            expect(owned_question.body).to eq "New body"
          end
        end

        context "with invalid attributes" do
          it "does not updates question" do
            patch :update, xhr: true, params: { id: owned_question, question: attributes_for(:invalid_question) }
            owned_question.reload
            expect(owned_question.title).not_to be_empty
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context "not owner of the question" do
        it "returns 404 with no content" do
          patch :update, xhr: true, params: { id: question, question: attributes_for(:question) }
          expect(response.status).to eq 403
          expect(response.body).to be_empty
        end

        it "does not updates question" do
          patch :update, xhr: true, params: { id: question, question: { title: "New title" } }
          question.reload
          expect(question.title).not_to eq "New title"
        end
      end
    end

    describe 'DELETE #destroy' do
      context "owner of the question" do
        it "deletes question from database" do
          owned_question
          expect { delete :destroy, params: { id: owned_question } }.to change(user.questions, :count).by(-1)
        end

        it "deletes dependent answers from database" do
          create(:answer, question: owned_question)
          expect { delete :destroy, params: { id: owned_question } }.to change(Answer, :count).by(-1)
        end

        it "redirects to root_path" do
          delete :destroy, params: { id: owned_question }
          expect(response).to redirect_to root_path
        end
      end

      context "not owner of the question" do
        it "does not deletes question from database" do
          question
          expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        end

        it "redirects to root_path" do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
