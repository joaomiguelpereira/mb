class CreateSpecialities < ActiveRecord::Migration
  def self.up
    create_table :specialities do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    add_index :specialities, :name 
  end
  
  def self.down
    remove_index :specialities, :name 
    drop_table :specialities
  end
end
