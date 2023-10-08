class Brand < ApplicationRecord
  has_many :custom_fields, as: :custom_fieldable, dependent: :destroy
  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true, limit: 5

  belongs_to :admin

  enum status: {inactive: 0, active: 1}

  validates :name, presence: true
  validates :name, length: { maximum: 20 }
end
