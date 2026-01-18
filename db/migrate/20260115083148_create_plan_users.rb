class CreatePlanUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_users do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
