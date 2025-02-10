class SplitResolutionFromScreens < ActiveRecord::Migration[8.0]
  def change
    remove_column :screens, :resolution, :string
    add_column :screens, :width, :integer
    add_column :screens, :height, :integer
  end
end
