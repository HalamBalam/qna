class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question, null: false
      t.references :user

      t.timestamps
    end
  end
end
