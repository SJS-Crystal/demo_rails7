class ProductSerializer < ApplicationSerializer
  attributes :id, :name, :brand_id, :price, :currency_id, :stock, :brand_name

  def price
    "#{object.price} #{object.currency.name}"
  end

  def brand_name
    object.brand.name
  end
end
