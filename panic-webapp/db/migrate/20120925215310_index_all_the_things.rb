class IndexAllTheThings < ActiveRecord::Migration
  def change
    add_index :credentials, :leak_id
    add_index :credentials, [ :leak_id, :password ]
  end
end
