require 'rails_helper'

RSpec.describe Api::Client::V1::ProductsController, type: :controller do
  let!(:admin) { create(:admin) }
  let!(:client) { create(:client, admin: admin) }
  let!(:device) { create(:device, client: client) }
  let!(:product) { create(:product, admin: admin) }
  let!(:jwt) { JwtService.generate_jwt_token(client.id, device.device_id, device.secret) }

  before do
    request.headers['Authorization'] = "Bearer #{jwt}"
    request.headers['Device-Id'] = device.device_id
  end

  describe 'GET #all' do
    it 'returns all products from client\'s admin' do
      10.times { create(:product, admin: admin) }
      get :all, params: { page: 1, items: 5 }
      parsed_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(parsed_response['data'].size).to eq 5
      expect(parsed_response['message']).to eq 'success'
      expect(parsed_response['data'].first).to include(
        'id',
        'name',
        'brand_id',
        'price',
        'currency_id',
        'stock',
        'brand_name'
      )
    end
  end

  describe 'GET #index' do
    it 'returns only products in view' do
      viewable_products = create_list(:product, 5, admin: admin)
      not_viewable_product = create(:product, admin: admin)

      client.viewable_products << viewable_products

      get :index, params: { page: 1, items: 5 }

      expect(response.status).to eq 200
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'].size).to eq 5
      expect(parsed_response['message']).to eq 'success'

      returned_ids = parsed_response['data'].map { |product| product['id'] }
      expect(returned_ids).to match_array(viewable_products.map(&:id))
      expect(returned_ids).not_to include(not_viewable_product.id)
    end
  end

  describe 'PUT #add_to_view' do
    it 'adds product to view' do
      expect {
        put :add_to_view, params: { product_id: product.id }
      }.to change { client.viewable_products.count }.by(1)

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'success'
    end
  end

  describe 'PUT #remove_from_view' do
    before do
      client.viewable_products << product
    end

    it 'removes product from view' do
      expect {
        put :remove_from_view, params: { product_id: product.id }
      }.to change { client.viewable_products.count }.by(-1)

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'success'
    end
  end
end
