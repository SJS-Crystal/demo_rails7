class CardSerializer < ApplicationSerializer
  attributes :id, :product_id, :client_id, :activation_code, :status, :purchase_pin, :price,
    :created_at, :updated_at

  def price
    "#{object.price} #{object.currency}"
  end
end
