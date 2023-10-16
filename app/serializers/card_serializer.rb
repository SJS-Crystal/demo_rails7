class CardSerializer < ApplicationSerializer
  attributes :id, :product_id, :client_id, :activation_code, :status, :purchase_pin, :price, :usd_price,
    :created_at, :updated_at

  def price
    "#{object.price} #{object.currency}"
  end

  def usd_price
    object.usd_price.to_f
  end

  def status
    object.status.humanize.titleize
  end
end
