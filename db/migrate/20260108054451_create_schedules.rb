class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.string :title, null: false
      t.datetime :start_time, null: false
      t.string :memo, null: false
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
