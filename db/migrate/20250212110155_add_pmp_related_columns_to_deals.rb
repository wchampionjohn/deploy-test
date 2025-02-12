class AddPmpRelatedColumnsToDeals < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :bidfloor, :decimal, precision: 10, scale: 4, comment: '底價'
    add_column :deals, :bidfloorcur, :string, comment: '底價幣別'
    add_column :deals, :auction_type, :string, comment: 'First Price Auction, Second Price Auction'
  end
end
