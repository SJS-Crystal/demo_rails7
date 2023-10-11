require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'validations' do
    subject { Currency.new(name: 'USD') }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
