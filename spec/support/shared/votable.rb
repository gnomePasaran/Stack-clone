shared_examples "votable" do
  let(:vote_up) { post :vote_up, xhr: true, params: shared_context }
  let(:vote_down) { post :vote_down, xhr: true, params: shared_context }

  context "as guest" do
    describe 'POST #vote' do
      it "responses with 401" do
        vote_up
        expect(response.status).to eq 401
      end
    end
  end

  context "as user" do
    before { sign_in user }

    describe 'POST #vote' do
      it "assigns votable to @votable" do
        vote_up
        expect(assigns(:votable)).to eq votable
      end

      it "responses with 200" do
        vote_up
        expect(response.status).to eq 200
      end

      context "owner" do
        it 'does not votes up\down', :aggregate_failures do
          expect { post :vote_up, params: shared_context.merge(id: owned_votable) }.not_to change(owned_votable.votes, :count)
          expect { post :vote_down, params: shared_context.merge(id: owned_votable) }.not_to change(owned_votable.votes, :count)
          expect { post :cancel_vote, params: shared_context.merge(id: owned_votable) }.not_to change(owned_votable.votes, :count)
        end
      end

      context "not owner" do
        it "votes up" do
          expect { vote_up }.to change(votable.votes, :count).by(1)
        end

        it "votes down" do
          expect { vote_down }.to change(votable.votes, :count).by(1)
        end

        it "removes vote" do
          create(:vote, user: user, votable: votable)
          expect { post :cancel_vote, xhr: true, params: shared_context }.to change(votable.votes, :count).by(-1)
        end
      end
    end
  end
end
