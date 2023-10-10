class AccessibleProduct < ApplicationRecord
  belongs_to :client
  belongs_to :product
  validates :product_id, uniqueness: { scope: :client_id, message: "has already been added" }
end
