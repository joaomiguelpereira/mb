class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.string :short_name
      t.string :full_name
      t.text :description
      t.text :address
      t.string :city
      t.string :postal_code
      t.string :email
      t.string :phone
      t.string :fax
      t.string :url
      t.string :facebook
      t.string :twitter
      t.integer :business_admin_id
      
      t.boolean :publised
      t.timestamps
    end
  end
  
  def self.down
    drop_table :businesses
  end
end
