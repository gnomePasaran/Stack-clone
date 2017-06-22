class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
