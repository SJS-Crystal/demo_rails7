require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#notice_classes' do
    it 'returns a hash of notice classes' do
      classes = helper.notice_classes

      expect(classes[:success]).to eq(:success)
      expect(classes[:error]).to eq(:danger)
      expect(classes[:alert]).to eq(:info)
    end
  end

  describe '#custom_fields_td' do
    it 'returns the HTML for custom fields in a table cell' do
      brand = FactoryBot.create(:brand)

      custom_field1 = FactoryBot.create(:custom_field, name: 'Field 1', value: 'Value 1', custom_fieldable: brand)
      custom_field2 = FactoryBot.create(:custom_field, name: 'Field 2', value: 'Value 2', custom_fieldable: brand)

      html = helper.custom_fields_td(brand, Settings.max_brand_custom_field)

      expect(html).to include('Field 1')
      expect(html).to include('Field 2')
      expect(html).to include('Value 1')
      expect(html).to include('Value 2')
    end
  end

  describe '#custom_fields_th' do
    it 'returns the HTML for table headers of custom fields' do
      html = helper.custom_fields_th(3)

      expect(html).to include('Custom field 1')
      expect(html).to include('Custom field 2')
    end
  end

  describe '#enum_collection' do
    it 'returns a collection of enum values with their keys capitalized' do
      collection = helper.enum_collection(Brand, 'status')

      expect(collection.sort).to eq([['Active', 'active'], ['Inactive', 'inactive']].sort)
    end
  end

  describe '#brand_collection' do
    it 'returns a collection of brand names with their IDs' do
      brand1 = FactoryBot.create(:brand, name: 'Brand 1')
      brand2 = FactoryBot.create(:brand, name: 'Brand 2')

      collection = helper.brand_collection

      expect(collection).to eq([['Brand 1', brand1.id], ['Brand 2', brand2.id]])
    end
  end

  describe '#currency_collection' do
    it 'returns a collection of currency names with their IDs' do
      currency1 = FactoryBot.create(:currency, name: 'USD')
      currency2 = FactoryBot.create(:currency, name: 'EUR')

      collection = helper.currency_collection

      expect(collection).to eq([['USD', currency1.id], ['EUR', currency2.id]])
    end
  end

  describe '#order_status_collection' do
    it 'returns an array of humanized statuses and original values' do
      expected_result = [['Issued', 'issued'], ['Rejected', 'rejected']]
      expect(helper.order_status_collection).to eq(expected_result)
    end
  end

  describe '#badge_status' do
    it 'returns a badge with the correct class and content' do
      obj = instance_double("Brand", status: 'active')

      expect(helper.badge_status(obj)).to eq(
        '<div class="badge badge-success badge-lg">Active</div>'
      )
    end
  end
end
