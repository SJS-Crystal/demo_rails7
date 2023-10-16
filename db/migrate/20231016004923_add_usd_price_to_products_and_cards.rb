class AddUsdPriceToProductsAndCards < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :usd_price, :decimal, precision: 10, scale: 2, null: false
    add_column :cards, :usd_price, :decimal, precision: 10, scale: 2, null: false
    change_column :products, :price, :decimal, precision: 10, scale: 2, null: false
    change_column :cards, :price, :decimal, precision: 10, scale: 2, null: false
  end
end
