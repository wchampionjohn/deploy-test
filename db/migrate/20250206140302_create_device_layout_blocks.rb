class CreateDeviceLayoutBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :device_layout_blocks do |t|
      t.bigint :device_id, comment: '關聯的裝置ID'
      t.bigint :device_layout_id
      t.integer :width
      t.integer :height
      t.integer :lookr_id
      t.integer :index

      t.timestamps
    end
  end
end
