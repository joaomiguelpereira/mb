class CreateBusinessAdmins < ActiveRecord::Migration
  def self.up
    change_table :users do |t|      
      t.integer :business_account_id
    end
    
  end
  
  def self.down
    remove_column :users, :business_account_id
  end
end
