require 'rails_helper'

RSpec.describe CustomField, type: :model do
  it { should belong_to(:custom_fieldable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }

  it { should validate_length_of(:name).is_at_most(20) }
  it { should validate_length_of(:value).is_at_most(100) }
end
