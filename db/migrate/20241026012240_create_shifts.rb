class CreateShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :shifts do |t|
      t.integer :weekday, null: false
      t.time :opening_time, null: false
      t.time :closing_time, null: false

      t.timestamps
    end
  end
end
