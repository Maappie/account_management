class ChangeDefaultForRolesInAccounts < ActiveRecord::Migration[8.0]
  def change
    change_column_default :accounts, :roles, from: nil, to: "a"
  end
end
