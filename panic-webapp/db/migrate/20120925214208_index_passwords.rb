class IndexPasswords < ActiveRecord::Migration
  def change
    add_index :credentials, :password
  end
end
