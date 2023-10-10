class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :product, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :activation_code, null: false
      t.integer :status, default: 0
      t.string :purchase_pin, null: false
      t.float :price, null: false
      t.string :currency, null: false

      t.timestamps
    end

    add_index :cards, :activation_code, unique: true
    add_index :cards, :purchase_pin, unique: true
  end
end
