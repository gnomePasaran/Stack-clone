shared_context "users", :users do
  let(:user) { create(:user) }
end

shared_context "auth", :auth do
  before { sign_in user }
end
