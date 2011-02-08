class AddActivationToUser < ActiveRecord::Migration
  def self.up
    
    change_table :users do |t|
      t.boolean :active, :default => false
      t.string :activation_key
    end
  end
  
  def self.down
    remove_column :users, :active
    remove_column :users, :activation_key
  end
end
