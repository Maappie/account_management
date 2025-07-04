class AddVerifiedToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :verified, :boolean, default: false
  end
end
