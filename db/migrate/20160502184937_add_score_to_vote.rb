class AddScoreToVote < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :score, :integer, limit: 1
  end
end
