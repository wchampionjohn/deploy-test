class CreateAdUnitTimeMultipliers < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_unit_time_multipliers do |t|
      t.bigint :ad_unit_id
      t.integer :day_of_week, comment: '星期幾'
      t.time :start_time, comment: '開始時間'
      t.time :end_time, comment: '結束時間'
      t.decimal :multiplier, precision: 10, scale: 4
      t.timestamps
    end

    add_index :ad_unit_time_multipliers, :ad_unit_id
  end
end
