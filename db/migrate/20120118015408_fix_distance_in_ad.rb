class FixDistanceInAd < ActiveRecord::Migration
  def self.up
	# below doesn't work
  	# alter_column :ads, :distance, :integer, :default => 0
	change_table(:ads) do |t|
		t.remove :distance
		t.column :distance, :integer, :default => 0
	end

  	add_index :ads, :distance
  end

  def self.down
  	remove_index :ads, :distance
  	#alter_column :ads, :distance, :decimal, :default => 0.0
	change_table(:ads) do |t|
		t.remove :distance
		t.column :distance, :decimal, :default => 0.0
	end
  end
end
