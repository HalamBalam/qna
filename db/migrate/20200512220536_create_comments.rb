class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user,        null: false
      t.references :commentable, null: false, polymorphic: true
      t.string     :body,        null: false
      t.timestamps
    end
  end
end
