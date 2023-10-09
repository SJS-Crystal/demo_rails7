class Product < ApplicationRecord
  has_many :custom_fields, as: :custom_fieldable, dependent: :destroy
  belongs_to :brand
  belongs_to :currency, optional: true
  belongs_to :admin

  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true, limit: Settings.max_product_custom_field

  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :price, presence: true
  validates :stock, presence: true
end
