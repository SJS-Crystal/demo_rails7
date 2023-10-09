class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.references :brand, null: false, foreign_key: true
      t.integer :status, default: 0
      t.float :price, null: false
      t.references :currency, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.integer :stock, null: false

      t.timestamps
    end
  end
end
