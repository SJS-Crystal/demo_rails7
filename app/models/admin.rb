class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :brands, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 10 }
end
