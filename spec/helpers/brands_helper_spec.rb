require 'rails_helper'

RSpec.describe Admin::BrandsHelper, type: :helper do
  describe '#custom_fields_td' do
    it 'returns the HTML for custom fields in a table cell' do
      brand = FactoryBot.create(:brand)

      custom_field1 = FactoryBot.create(:custom_field, name: 'Field 1', value: 'Value 1', custom_fieldable: brand)
      custom_field2 = FactoryBot.create(:custom_field, name: 'Field 2', value: 'Value 2', custom_fieldable: brand)

      html = helper.custom_fields_td(brand)

      expect(html).to include('Field 1')
      expect(html).to include('Field 2')
      expect(html).to include('Value 1')
      expect(html).to include('Value 2')
    end
  end

  describe '#custom_fields_th' do
    it 'returns the HTML for table headers of custom fields' do
      html = helper.custom_fields_th

      expect(html).to include('Custom field 1')
      expect(html).to include('Custom field 2')
    end
  end
end
