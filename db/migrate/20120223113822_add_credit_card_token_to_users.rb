class AddCreditCardTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :credit_card_token, :string
  end

  def self.down
    remove_column :users, :credit_card_token
  end
end
