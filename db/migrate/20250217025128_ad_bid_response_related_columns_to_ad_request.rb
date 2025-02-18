class AdBidResponseRelatedColumnsToAdRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_requests, :bid_response, :jsonb
    add_column :ad_requests, :win_bid_id, :string
    add_column :ad_requests, :win_bid_price, :decimal, precision: 10, scale: 4
    add_column :ad_requests, :win_bid_imp_id, :string
  end
end
