class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.string :title, null: false
      t.text :status, null: false
      t.integer :confirmed_date, null: false
      

      t.timestamps
    end
  end
end
