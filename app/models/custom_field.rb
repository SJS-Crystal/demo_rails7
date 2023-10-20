class CustomField < ApplicationRecord
  belongs_to :custom_fieldable, polymorphic: true

  validates :name, :value, presence: true
  validates :name, length: {maximum: 20}
  validates :value, length: {maximum: 100}
end
