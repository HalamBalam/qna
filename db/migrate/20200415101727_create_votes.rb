class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user,    null: false
      t.references :votable, null: false, polymorphic: true
      t.integer    :rating,  null: false
      t.timestamps

      t.index [ :user_id, :votable_type, :votable_id ], name: "index_votes_uniqueness", unique: true
    end
  end
end
