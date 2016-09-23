class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
    
    add_index :authorizations, [:provider, :uid]
    add_foreign_key :authorizations, :users
  end
end
