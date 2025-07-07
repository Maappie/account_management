class AddRolesToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :roles, :string
  end
end
