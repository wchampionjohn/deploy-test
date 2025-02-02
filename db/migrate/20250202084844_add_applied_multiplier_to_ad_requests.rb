class AddAppliedMultiplierToAdRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_requests, :applied_multiplier, :decimal, precision: 10, scale: 4, comment: '廣告單元底價倍率'
  end
end
