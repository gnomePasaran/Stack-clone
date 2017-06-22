shared_examples "API unaccessable" do |method, path|
  it "returns 401 status without access_token" do
    send method, path, params: { format: :json }
    expect(response.status).to eq 401
  end

  it "returns 401 status when access_token invalid" do
    send method, path, params: { access_token: "1234", format: :json }
    expect(response.status).to eq 401
  end
end
