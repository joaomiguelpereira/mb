class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :workers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :phone
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workers
  end
end
