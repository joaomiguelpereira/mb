class UsersAddResetPasswordKey < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :reset_password_key
    end
  end

  def self.down
    remove_column :users, :reset_password_key
  end
end
