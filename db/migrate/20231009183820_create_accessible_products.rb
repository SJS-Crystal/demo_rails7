class CreateAccessibleProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :accessible_products do |t|
      t.references :client, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
