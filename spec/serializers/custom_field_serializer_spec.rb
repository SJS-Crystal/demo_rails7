require 'rails_helper'

RSpec.describe CustomFieldSerializer, type: :serializer do
  let(:custom_field) { create(:custom_field) }
  let(:serializer) { described_class.new(custom_field) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }

  it 'matches the expected json structure' do
    expect(json).to eq(
      'id' => custom_field.id,
      'name' => custom_field.name,
      'value' => custom_field.value
    )
  end
end
