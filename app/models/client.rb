class Client < ApplicationRecord
  has_secure_password
  has_many :devices, dependent: :destroy

  belongs_to :admin

  validates :username, presence: true, uniqueness: true
  validates :password, length: (6..20), allow_nil: true
  validates :name, presence: true
  validates :payout_rate, presence: true
  validates :balance, presence: true
end
