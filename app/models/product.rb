class Product < ApplicationRecord
  has_many :custom_fields, as: :custom_fieldable, dependent: :destroy
  has_many :accessible_products, dependent: :destroy
  has_many :cards

  belongs_to :brand
  belongs_to :admin

  delegate :name, to: :brand, prefix: true

  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true, limit: Settings.max_product_custom_field

  enum status: {inactive: 0, active: 1}

  validates :currency, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :usd_price, presence: true
  validates :stock, presence: true
end
