class CreateBusinessAccountSpecialities < ActiveRecord::Migration
  def self.up
    create_table :business_account_specialities do |t|
      t.integer :business_account_id
      t.integer :speciality_id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :business_account_specialities
  end
end
