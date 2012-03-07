class DeviseCreatePublishers < ActiveRecord::Migration
  def self.up
    create_table(:publishers) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
	t.string :name

      t.timestamps
    end

    add_index :publishers, :email,                :unique => true
    add_index :publishers, :reset_password_token, :unique => true
    add_index :publishers, :name, :unique => true
    # add_index :publishers, :confirmation_token,   :unique => true
    # add_index :publishers, :unlock_token,         :unique => true
    # add_index :publishers, :authentication_token, :unique => true
  end

  def self.down
    drop_table :publishers
  end
end
