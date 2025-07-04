class AddVerificationCodeToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :verification_code, :string
  end
end
