class CreateOmniauthAccounts < ActiveRecord::Migration
  def change
    create_table :omniauth_accounts do |t|
      t.string :uid     , null: false, default: ""
      t.string :provider, null: false, default: ""
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :omniauth_accounts, [:provider, :uid]
  end
end
