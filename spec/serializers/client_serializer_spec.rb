require 'rails_helper'

RSpec.describe ClientSerializer, type: :serializer do
  let(:client) { create(:client) }
  let(:serializer) { described_class.new(client) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }

  it 'includes id' do
    expect(subject['id']).to eq(client.id)
  end

  it 'includes name' do
    expect(subject['name']).to eq(client.name)
  end

  it 'includes username' do
    expect(subject['username']).to eq(client.username)
  end

  it 'includes balance' do
    expect(subject['balance']).to eq(client.balance)
  end

  it 'includes payout_rate' do
    expect(subject['payout_rate']).to eq(client.payout_rate)
  end
end
