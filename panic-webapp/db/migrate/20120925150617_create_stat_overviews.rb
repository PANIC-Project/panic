class CreateStatOverviews < ActiveRecord::Migration
  def change
    create_table :stat_overviews do |t|
      t.text :strength_points
      t.text :length_points
      t.text :complexity_points

      t.text :length_distribution
      t.text :strength_distribution
      t.text :complexity_distribution

      t.text :most_common_passwords

      t.timestamps
    end
  end
end
