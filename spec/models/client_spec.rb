require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:admin) { FactoryBot.create(:admin) }

  it { should belong_to(:admin) }
  it { should have_many(:devices).dependent(:destroy) }

  it 'is valid with valid attributes' do
    client = FactoryBot.build(:client, admin: admin)
    expect(client).to be_valid
  end

  it 'is invalid without a username' do
    client = FactoryBot.build(:client, username: nil, admin: admin)
    expect(client).to_not be_valid
  end

  it 'is invalid with a duplicate username' do
    existing_client = FactoryBot.create(:client, username: 'testuser', admin: admin)
    new_client = FactoryBot.build(:client, username: 'testuser', admin: admin)
    expect(new_client).to_not be_valid
  end

  it 'is invalid without a password' do
    client = FactoryBot.build(:client, password: nil, admin: admin)
    expect(client).to_not be_valid
  end

  it 'is valid with a password between 6 and 20 characters' do
    client = FactoryBot.build(:client, password: '123456', admin: admin)
    expect(client).to be_valid
  end

  it 'is invalid with a password less than 6 characters' do
    client = FactoryBot.build(:client, password: '12345', admin: admin)
    expect(client).to_not be_valid
  end

  it 'is invalid with a password more than 20 characters' do
    client = FactoryBot.build(:client, password: '1234567890112309128390213', admin: admin)
    expect(client).to_not be_valid
  end

  it 'is invalid without a name' do
    client = FactoryBot.build(:client, name: nil, admin: admin)
    expect(client).to_not be_valid
  end

  it 'is invalid without a payout_rate' do
    client = FactoryBot.build(:client, payout_rate: nil, admin: admin)
    expect(client).to_not be_valid
  end

  it 'is invalid without a balance' do
    client = FactoryBot.build(:client, balance: nil, admin: admin)
    expect(client).to_not be_valid
  end

  it 'belongs to an admin' do
    client = FactoryBot.create(:client, admin: admin)
    expect(client.admin).to eq(admin)
  end
end
