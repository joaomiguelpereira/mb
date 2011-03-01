class CreateStaffers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|      
      #t.integer :business_account_id
    end
    
    #change_table :users do |t|
    #  t.string :type
    #end
  end
  
  def self.down
    #drop_table :type
    #remove_column :users, :business_account_id
  end
end
