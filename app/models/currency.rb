class Currency < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
