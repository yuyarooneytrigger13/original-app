class CreateVisitedRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :visited_records do |t|
      t.references :user,       null: false, foreign_key: true
      t.integer :prefecture, null: false
      t.date :visited_date,     null: false
      t.string :review,         null: false

      t.timestamps
    end
  end
end
