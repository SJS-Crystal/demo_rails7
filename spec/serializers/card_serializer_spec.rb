require 'rails_helper'

RSpec.describe CardSerializer, type: :serializer do
  let(:card) { create(:card) }
  let(:serializer) { described_class.new(card) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }
  let(:expected_attributes) {
    {
      "id" => card.id,
      "product_id" => card.product_id,
      "client_id" => card.client_id,
      "activation_code" => card.activation_code,
      "status" => "pending_approval".humanize.titleize,
      "purchase_pin" => card.purchase_pin,
      "price" => "#{card.price} #{card.currency}",
      "created_at" => card.created_at.as_json,
      "updated_at" => card.updated_at.as_json
    }
  }

  it "serializes the card object correctly" do
    expect(json).to eq(expected_attributes)
  end
end
