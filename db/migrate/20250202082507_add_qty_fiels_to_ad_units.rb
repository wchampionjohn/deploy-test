class AddQtyFielsToAdUnits < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_units, :qty_multiplier, :decimal, precision: 10, scale: 4, comment: '廣告單元底價倍率'
    add_column :ad_units, :qty_source_type, :integer, default: 0, comment: '廣告單元底價來源類型'
    add_column :ad_units, :qty_vendor, :string, comment: '廣告單元底價來源廠商'
    add_column :ad_units, :qty_ext, :jsonb
  end
end
