class AddUniqueIndexToAccessibleProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :accessible_products, [:client_id, :product_id], unique: true
  end
end
