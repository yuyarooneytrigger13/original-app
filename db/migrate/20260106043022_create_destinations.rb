class CreateDestinations < ActiveRecord::Migration[7.1]
  def change
    create_table :destinations do |t|
      t.string :name,      null: false
      t.text :description, null: false
      t.integer :likes_count, default: 0, null: false
      t.references :plan,  null: false, foreign_key: true
      t.references :user,  null: false, foreign_key: true

      t.timestamps
    end
  end
end
