class AddDoohRelativeAttributes < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_spaces, :venue_type, :string, comment: 'DOOH venue type (e.g., AIRPORT, MALL)'
    add_column :ad_spaces, :venue_name, :string, comment: 'Name of the venue'

    add_column :ad_units, :fps, :integer, comment: 'Frames per second for DOOH displays'
    add_column :ad_units, :min_duration, :integer, comment: 'Minimum duration in seconds'
    add_column :ad_units, :max_duration, :integer, comment: 'Maximum duration in seconds'
  end
end
