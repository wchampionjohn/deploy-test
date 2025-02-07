class CreateDeviceLayouts < ActiveRecord::Migration[8.0]
  def change
    create_table :device_layouts do |t|
      t.bigint :device_id, comment: '關聯的裝置ID'
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end
end
