class ChangeConfirmedDateNullOnPlans < ActiveRecord::Migration[7.1]
  def change
    change_column_null :plans, :confirmed_date, true
  end
end
