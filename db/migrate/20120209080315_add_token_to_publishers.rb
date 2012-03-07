class AddTokenToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :token, :string
  end

  def self.down
    remove_column :publishers, :token
  end
end
