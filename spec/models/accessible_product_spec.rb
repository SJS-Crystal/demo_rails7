require 'rails_helper'

RSpec.describe AccessibleProduct, type: :model do
  let!(:accessible_product) { create(:accessible_product) }

  it { should belong_to(:client) }
  it { should belong_to(:product) }
  it { should validate_uniqueness_of(:product_id).scoped_to(:client_id).with_message("has already been added") }
end
