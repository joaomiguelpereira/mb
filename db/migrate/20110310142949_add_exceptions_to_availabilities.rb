class AddExceptionsToAvailabilities < ActiveRecord::Migration
  def self.up
     add_column :availabilities, :exceptions_json_data, :text
  end

  def self.down
    remove_column :availabilities, :exceptions_json_data 
  end
end
