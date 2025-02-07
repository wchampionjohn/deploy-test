class AddCommissionRelativeSchema < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :total_budget, :decimal, precision: 15, scale: 4, comment: '總預算金額'
    add_column :deals, :spent_budget, :decimal, precision: 15, scale: 4, default: 0, comment: '已花費預算'
    add_column :deals, :commission_rate, :decimal, precision: 5, scale: 2, comment: '佣金比率(%)'
    add_column :deals, :commission_type, :string, comment: '佣金類型: visible(顯示), hidden(隱藏)'
    add_column :deals, :commission_settings, :jsonb, default: {}, comment: '佣金設定，如最低金額、階梯式佣金等'

    add_column :impressions, :publisher_revenue, :decimal, precision: 10, scale: 4, comment: '發布商收益'
    add_column :impressions, :platform_revenue, :decimal, precision: 10, scale: 4, comment: '平台收益(佣金)'
    add_column :impressions, :commission_rate_snapshot, :decimal, precision: 5, scale: 2, comment: '執行時的佣金比率快照(%)'
    add_column :impressions, :currency, :string, default: 'USD', comment: '貨幣類型'

    add_column :publishers, :default_commission_rate, :decimal, precision: 5, scale: 2, comment: '預設佣金比率(%)'
    add_column :publishers, :commission_settings, :jsonb, default: {}, comment: '佣金設定，如最低金額、階梯式佣金等'
    add_column :publishers, :hide_commission, :boolean, default: false, comment: '是否隱藏佣金資訊'

    add_index :deals, :commission_type
    add_index :impressions, [ :deal_id, :publisher_revenue ]
    add_index :impressions, [ :deal_id, :platform_revenue ]
  end
end
