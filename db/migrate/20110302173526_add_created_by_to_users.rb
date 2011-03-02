class AddCreatedByToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_by, :integer, :default=>nil
  end

  def self.down
    remove_column :users, :created_by 
  end
end
