class AddUniqueIndexToCurrencies < ActiveRecord::Migration[7.0]
  def change
    add_index :currencies, :name, unique: true
  end
end
