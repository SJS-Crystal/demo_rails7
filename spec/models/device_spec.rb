require 'rails_helper'

RSpec.describe Device, type: :model do
  it { should belong_to(:client) }
  it { should validate_presence_of(:device_id) }
  it { should validate_presence_of(:secret) }

  describe 'validations' do
    subject { build(:device) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a device_id' do
      subject.device_id = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a secret' do
      subject.secret = nil
      expect(subject).not_to be_valid
    end
  end
end
