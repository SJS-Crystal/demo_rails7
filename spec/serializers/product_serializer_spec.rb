require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  let(:currency) { create(:currency, name: 'USD') }
  let(:brand) { create(:brand, name: 'Apple') }
  let(:product) { create(:product, name: 'iPhone', brand: brand, price: 1000, currency: currency, stock: 10) }
  let(:serializer) { described_class.new(product) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_product) { JSON.parse(serialization.to_json) }

  it 'serializes product attributes' do
    expect(serialized_product).to eq({
      'id' => product.id,
      'name' => 'iPhone',
      'brand_id' => brand.id,
      'price' => '1000.0 USD',
      'currency_id' => currency.id,
      'stock' => 10,
      'brand_name' => 'Apple'
    })
  end
end
