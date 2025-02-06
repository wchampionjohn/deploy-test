class AddLookrIdToDevices < ActiveRecord::Migration[8.0]
  def change
    add_column :devices, :lookr_id, :integer, comment: "來自 Lookr 的裝置 ID，用來fetch裝置的詳細資料"
  end
end
