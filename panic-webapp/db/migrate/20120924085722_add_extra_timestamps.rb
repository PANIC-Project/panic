class AddExtraTimestamps < ActiveRecord::Migration
  def change
    add_column :leaks, :leaked_on, :datetime
  end
end
