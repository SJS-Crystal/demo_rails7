class ProductSerializer < ApplicationSerializer
  attributes :id, :name, :brand_id, :price, :currency, :stock, :brand_name, :status

  has_many :custom_fields

  def price
    "#{object.price} #{object.currency}"
  end

  def brand_name
    object.brand.name
  end
end
