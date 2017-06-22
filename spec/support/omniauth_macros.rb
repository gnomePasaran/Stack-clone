module OmniauthMacros
  def mock_auth_hash(hash = {})
    hash = { provider: "facebook", uid: "123", info: { email: "provider@example.com" } }.merge(hash)
    OmniAuth.config.mock_auth[hash[:provider].to_sym] = OmniAuth::AuthHash.new(hash)
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
