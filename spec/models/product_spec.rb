require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should have_many(:custom_fields).dependent(:destroy) }
    it { should belong_to(:brand) }
    it { should belong_to(:currency).optional(true) }
    it { should belong_to(:admin) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:custom_fields).allow_destroy(true).limit(Settings.max_product_custom_field) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(active: 1, inactive: 0) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
  end
end
