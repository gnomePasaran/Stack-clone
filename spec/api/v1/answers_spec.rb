require "rails_helper"

describe "Answers API" do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }

  context "authorized" do
    describe 'GET #index' do
      let!(:answers) { create_pair(:answer, question: question) }
      let(:answer) { answers.first }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, format: :json }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "returns answers" do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    describe 'GET #show' do
      let!(:answer) { create(:answer) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before do
        get "/api/v1/questions/#{answer.question.id}/answers/#{answer.id}", params: { access_token: access_token.token, format: :json }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "comments" do
        it "includes comments" do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "includes attachments" do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains filename" do
          expect(response.body).to be_json_eql(attachment.file.filename.to_json).at_path("attachments/0/filename")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end

    describe 'POST #create' do
      let!(:question) { create(:question) }

      context "with valid params" do
        let(:post_answer) do
          post "/api/v1/questions/#{question.id}/answers", params: {
            access_token: access_token.token, format: :json, answer: attributes_for(:answer), question_id: question
          }
        end

        it "returns 201 status" do
          post_answer
          expect(response.status).to eq 201
        end

        it "creates answer" do
          expect { post_answer }.to change(question.answers, :count).by(1)
        end
      end

      context "with invalid params" do
        let(:post_invalid_answer) do
          post "/api/v1/questions/#{question.id}/answers", params: {
            access_token: access_token.token, format: :json, answer: attributes_for(:invalid_answer), question_id: question
          }
        end

        it "returns 422 status" do
          post_invalid_answer
          expect(response.status).to eq 422
        end

        it "does not creates answer" do
          expect { post_invalid_answer }.not_to change(question.answers, :count)
        end
      end
    end
  end

  context "not authorized" do
    describe 'GET #index' do
      it_behaves_like "API unaccessable", :get, "/api/v1/questions/1/answers"
    end

    describe 'GET #show' do
      it_behaves_like "API unaccessable", :get, "/api/v1/questions/1/answers/1"
    end

    describe 'POST #create' do
      it_behaves_like "API unaccessable", :post, "/api/v1/questions/1/answers"
    end
  end
end
