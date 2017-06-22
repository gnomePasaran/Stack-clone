FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name "App"
    uid "54848563"
    secret "12345678"
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
  end
end
