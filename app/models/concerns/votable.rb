module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(score: 1)
  end

  def vote_down(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(score: -1)
  end

  def cancel_vote(user)
    return false unless voted_by?(user)
    votes.where(user: user).destroy_all
    true
  end

  def vote_score
    votes.sum(:score)
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
