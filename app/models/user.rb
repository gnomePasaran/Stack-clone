class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :identities, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    email = auth_email(auth)
    user = find_by(email: email) if email

    if user.present?
      user.create_identities(auth)
    elsif email
      user = create_user_from_auth(auth)
    else
      user = nil
    end

    user
  end

  def self.create_user_from_auth(auth)
    user = new(email: auth_email(auth), password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    user.save!
    user.create_identities(auth)
    user
  end

  def self.create_user_from_session(auth, email)
    user = new(email: email, password: Devise.friendly_token[0, 20])
    user.create_identities(auth) if user.save
    user
  end

  def create_identities(auth)
    identities.create!(provider: auth["provider"], uid: auth["uid"])
  end

  def self.auth_email(auth)
    auth.try(:info).try(:email)
  end
end
