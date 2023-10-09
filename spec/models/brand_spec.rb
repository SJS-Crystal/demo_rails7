require 'rails_helper'

RSpec.describe Brand, type: :model do
  it { should belong_to(:admin) }

  it { should have_many(:custom_fields).dependent(:destroy) }
  it { should have_many(:products).dependent(:destroy) }

  it { should define_enum_for(:status).with_values(inactive: 0, active: 1) }

  it { should validate_presence_of(:name) }

  it { should validate_length_of(:name).is_at_most(20) }

  it { should accept_nested_attributes_for(:custom_fields).allow_destroy(true).limit(Settings.max_brand_custom_field) }

  it "rejects new custom_fields if all attributes are blank" do
    options = Brand.nested_attributes_options[:custom_fields]
    reject_proc = options[:reject_if]
    result = reject_proc.call({"name" => "", "value" => ""})
    expect(result).to be_truthy
  end
end
