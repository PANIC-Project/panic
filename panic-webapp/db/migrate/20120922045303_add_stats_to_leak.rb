class AddStatsToLeak < ActiveRecord::Migration
  def change
    add_column :leaks, :stats, :text
    Leak.all.each { |l| l.recalc_stats; l.save }
  end
end
