class Admin::Brand < ApplicationRecord
  validates :name, presence: true
end
