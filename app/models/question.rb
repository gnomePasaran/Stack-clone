class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, -> { order(accepted: :desc, created_at: :asc) }, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  validates :title, :body, :user_id, presence: true

  after_commit { QuestionRelayJob.perform_later(self) }
  after_create_commit :subscribe_user
  after_update :notify_users, if: "body_changed?"

  private

  def subscribe_user
    subscriptions.create(user_id: user_id)
  end

  def notify_users
    QuestionUpdateNotifyJob.perform_later(self)
  end
end
