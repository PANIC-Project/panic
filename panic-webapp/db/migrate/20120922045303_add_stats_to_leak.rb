class AddStatsToLeak < ActiveRecord::Migration
  def change
    add_column :leaks, :stats, :text
  end
end
