class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :votable_id
      t.string :votable_type
      t.references :user, index: true
      t.timestamps
    end
    
    add_index :votes, [:votable_id, :votable_type]
    add_foreign_key :votes, :users
  end
end
