class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
