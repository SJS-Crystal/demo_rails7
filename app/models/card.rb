class Card < ApplicationRecord
  belongs_to :client
  belongs_to :product
  belongs_to :admin, optional: true

  enum status: { pending_approval: 0, issued: 1, active: 2, canceled: 3, rejected: 4 }

  validates :activation_code, presence: true, uniqueness: true
  validates :purchase_pin, presence: true, uniqueness: true
  validates :price, :currency, presence: true
  validates :usd_price, :currency, presence: true
  validates :currency, presence: true

  before_validation :generate_unique_codes, on: :create
  validate :check_product_stock, on: :create

  after_create :decrease_product_stock
  after_update :increase_product_stock, if: :canceled_or_rejected?

  private

  def check_product_stock
    if product.stock <= 0
      errors.add(:base, "Stock not available for the product")
    end
  end

  def decrease_product_stock
    product.decrement!(:stock)
  end

  def increase_product_stock
    product.increment!(:stock)
  end

  def canceled_or_rejected?
    saved_change_to_attribute?(:status) && (canceled? || rejected?)
  end

  def generate_unique_codes
    self.activation_code = generate_unique_code_for(:activation_code)
    self.purchase_pin = generate_unique_code_for(:purchase_pin)
  end

  def generate_unique_code_for(attribute)
    loop do
      code = SecureRandom.hex(10)
      break code unless Card.exists?(attribute => code)
    end
  end
end
