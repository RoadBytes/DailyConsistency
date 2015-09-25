class AddHabit < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.string  :description
      t.integer :goal_id

      t.timestamps
    end
  end
end
