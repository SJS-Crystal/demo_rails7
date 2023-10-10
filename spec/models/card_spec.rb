require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { create :card }
  before do
    allow_any_instance_of(Card).to receive(:generate_unique_codes)
  end

  it { should belong_to(:client) }
  it { should belong_to(:product) }

  it { should define_enum_for(:status).with_values(pending_approval: 0, issued: 1, active: 2, canceled: 3, rejected: 4) }

  it { should validate_presence_of(:activation_code) }
  it { should validate_uniqueness_of(:activation_code) }
  it { should validate_presence_of(:purchase_pin) }
  it { should validate_uniqueness_of(:purchase_pin) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:currency) }

  it 'validates uniqueness of activation_code' do
    create(:card, activation_code: "same_code")
    card = build(:card, activation_code: "same_code")
    expect(card).not_to be_valid
    expect(card.errors[:activation_code]).to include("has already been taken")
  end

  it 'validates uniqueness of purchase_pin' do
    create(:card, purchase_pin: "same_pin")
    card = build(:card, purchase_pin: "same_pin")
    expect(card).not_to be_valid
    expect(card.errors[:purchase_pin]).to include("has already been taken")
  end

  describe '#check_product_stock' do
    context 'when stock is not available' do
      let(:product) { create(:product, stock: 0) }
      let(:card) { build(:card, product: product) }

      it 'adds an error' do
        card.valid?
        expect(card.errors[:base]).to include("Stock not available for the product")
      end
    end
  end

  describe '#decrease_product_stock' do
    let(:product) { create(:product, stock: 10) }

    it 'decreases the product stock by 1' do
      card = create(:card, product: product)
      expect { card.send :decrease_product_stock }.to change { product.reload.stock }.by(-1)
    end
  end

  describe '#increase_product_stock' do
    let(:product) { create(:product, stock: 10) }
    before { @card = create(:card, :issued, product: product) }

    it 'increases the product stock by 1' do
      expect { @card.update status: :canceled }.to change { product.reload.stock }.by(1)
    end

    it 'do not increase product stock' do
      expect { @card.update(status: :active) }.not_to change { product.reload.stock }
    end
  end

  describe '#canceled_or_rejected?' do
    let(:card) { create(:card, :issued) }

    context 'when status changes to canceled' do
      it 'returns true' do
        card.status = 'canceled'
        expect(card.send :canceled_or_rejected?).to be true
      end
    end

    context 'when status changes to canceled' do
      it 'returns true' do
        card.status = 'rejected'
        expect(card.send :canceled_or_rejected?).to be true
      end
    end

    context 'when status does not change to canceled or rejected' do
      it 'returns false' do
        card.status = 'active'
        expect(card.send :canceled_or_rejected?).to be false
      end
    end
  end
end
