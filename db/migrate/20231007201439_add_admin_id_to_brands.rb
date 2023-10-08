class AddAdminIdToBrands < ActiveRecord::Migration[7.0]
  def change
    add_reference :brands, :admin, null: false, foreign_key: true
    add_column :brands, :status, :integer, default: 0
    add_column :admins, :name, :string, null: false, limit: 10
  end
end
