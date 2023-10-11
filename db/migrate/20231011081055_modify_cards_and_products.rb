class ModifyCardsAndProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :cards, :admin, foreign_key: true
    remove_reference :products, :currency, foreign_key: true
    add_column :products, :currency, :string
  end
end
