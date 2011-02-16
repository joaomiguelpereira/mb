class AddNeedNewPasswordToStaffers < ActiveRecord::Migration
  def self.up
    add_column :users, :need_new_password, :boolean, :default=>false
    
  end
  
  def self.down
    remove_column :users, :need_new_password 
  end
end
