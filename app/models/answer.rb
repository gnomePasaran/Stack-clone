class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true

  after_commit :question_answer_relay, on: :create
  after_commit :question_answer_notification, on: :create

  scope :accepted, -> { where(accepted: true) }

  def toggle_accept!
    transaction do
      toggle(:accepted)
      question.answers.accepted.update_all(accepted: false) if accepted?
      save!
    end
  end

  private

  def question_answer_relay
    QuestionAnswerRelayJob.perform_later(self)
  end

  def question_answer_notification
    QuestionAnswerNotificationJob.perform_later(self)
  end
end
