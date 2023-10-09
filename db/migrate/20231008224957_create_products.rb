class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.integer :status
      t.float :price
      t.references :currency, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
