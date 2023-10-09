require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { create(:admin, name: 'Test Admin') }

  it { should have_many(:brands).dependent(:destroy) }
  it { should have_many(:products).dependent(:destroy) }
  it { should have_many(:clients).dependent(:destroy) }

  it { should validate_presence_of(:name) }

  it { should validate_length_of(:name).is_at_most(10) }

  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@example.com').for(:email) }
  it { should_not allow_value('invalid_email').for(:email) }

  it { should validate_presence_of(:email) }
  it "validates uniqueness of email" do
    expect(admin).to validate_uniqueness_of(:email).case_insensitive
  end
end
