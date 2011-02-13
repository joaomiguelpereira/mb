class AddAddressInfoToBusinesses < ActiveRecord::Migration
  def self.up
    change_table :businesses do |t|
      t.string :city
      t.string :postal_code
      t.boolean :publised
      
    end

  end

  def self.down
    remove_column :businesses, :city
    remove_column :businesses, :postal_code
    remove_column :published
    
  end
end
