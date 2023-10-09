class Currency < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true
end
