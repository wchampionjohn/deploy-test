class AddEstimatedDisplayTimeToAdRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_requests, :estimated_display_time, :datetime, comment: '預估顯示時間'
    add_index :ad_requests, :estimated_display_time
  end
end
