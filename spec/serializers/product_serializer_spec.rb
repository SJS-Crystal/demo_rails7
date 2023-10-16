require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  let(:currency) { create(:currency, name: 'USD') }
  let(:brand) { create(:brand, name: 'Apple') }
  let(:product) { create(:product, name: 'iPhone', brand: brand, price: 1000, usd_price: 2000, currency: currency.name, stock: 10) }
  let(:serializer) { described_class.new(product) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_product) { JSON.parse(serialization.to_json) }

  it 'serializes product attributes' do
    expect(serialized_product).to eq({
      'id' => product.id,
      'name' => 'iPhone',
      'brand_id' => brand.id,
      'price' => '1000.0 USD',
      'usd_price' => '2000.0',
      'custom_fields' => [],
      'currency' => currency.name,
      'stock' => 10,
      'status' => 'active',
      'brand_name' => 'Apple'
    })
  end
end
