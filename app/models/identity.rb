class Identity < ApplicationRecord
  belongs_to :user
  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_for_oauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end
end
