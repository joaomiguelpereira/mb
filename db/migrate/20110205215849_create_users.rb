class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :first_name
      t.string :last_name
      t.boolean :active, :default => false
      t.string :activation_key
      t.string :reset_password_key
      t.string :phone
      t.string :type
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
