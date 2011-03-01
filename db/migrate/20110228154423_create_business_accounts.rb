class CreateBusinessAccounts < ActiveRecord::Migration
  def self.up
    create_table :business_accounts do |t|
      t.integer :created_by_business_admin_id
      #t.integer :business_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :business_accounts
  end
end
