class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :username, null: false
      t.string :name, null: false
      t.string :password_digest, null: false
      t.float :payout_rate, default: 0
      t.float :balance, default: 0
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end

    add_index :clients, :username, unique: true
  end
end
