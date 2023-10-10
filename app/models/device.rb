class Device < ApplicationRecord
  belongs_to :client

  validates :device_id, :secret, presence: true
end
