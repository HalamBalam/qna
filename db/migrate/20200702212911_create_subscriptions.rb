class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false

      t.timestamps

      t.index [ :user_id, :question_id ], name: "index_subscriptions_uniqueness", unique: true
    end
  end
end
