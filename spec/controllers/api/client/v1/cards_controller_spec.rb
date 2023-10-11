require 'rails_helper'

RSpec.describe Api::Client::V1::CardsController, type: :controller do
  let(:currency) { create(:currency) }
  let!(:admin) { create(:admin) }
  let!(:client) { create(:client, admin: admin) }
  let!(:product) { create(:product, admin: admin) }
  let!(:device) { create(:device, client: client) }
  let!(:card) { create(:card, client: client, product: product) }
  let!(:jwt) { JwtService.generate_jwt_token(client.id, device.device_id, device.secret) }

  before do
    request.headers['Authorization'] = "Bearer #{jwt}"
    request.headers['Device-Id'] = device.device_id
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Card' do
        expect {
          post :create, params: { product_id: product.id }
        }.to change(Card, :count).by(1)
      end

      it 'returns a success response with the new card' do
        post :create, params: { product_id: product.id, currency_id: currency.id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Card requested successfully")
      end
    end

    context 'with invalid params' do
      it 'does not create a new Card' do
        expect {
          post :create, params: { product_id: nil }
        }.not_to change(Card, :count)
      end

      it 'returns an error response' do
        post :create, params: { product_id: nil }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(response.body).to include("success")
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: card.id }
      expect(response).to be_successful
      expect(response.body).to include(card.activation_code)
    end
  end

  describe 'PUT #cancel' do
    context 'when the card is issued' do
      let!(:issued_card) { create(:card, :issued, client: client) }

      it 'cancels the card' do
        put :cancel, params: { id: issued_card.id }
        expect(issued_card.reload).to be_canceled
      end

      it 'returns a success message' do
        put :cancel, params: { id: issued_card.id }
        expect(response.body).to include('Card canceled successfully')
      end
    end

    context 'when the card is not issued' do
      it 'does not cancel the card' do
        put :cancel, params: { id: card.id }
        expect(card.reload).not_to be_canceled
      end

      it 'returns an error message' do
        put :cancel, params: { id: card.id }
        expect(response.body).to include('Can only cancel issued card')
      end
    end
  end

  describe 'PUT #activate' do
    context 'when the activation code is correct' do
      let!(:issued_card) { create(:card, :issued, client: client) }

      it 'activates the card' do
        put :activate, params: { activation_code: issued_card.activation_code }
        expect(issued_card.reload).to be_active
      end

      it 'returns a success message' do
        put :activate, params: { activation_code: issued_card.activation_code }
        expect(response.body).to include('Card activated successfully')
      end
    end

    context 'when the activation code is incorrect' do
      it 'does not activate the card' do
        put :activate, params: { activation_code: 'incorrect_code' }
        expect(card.reload).not_to be_active
      end

      it 'returns an error message' do
        put :activate, params: { activation_code: 'incorrect_code' }
        expect(response.body).to include('Activation code is incorrect')
      end
    end
  end
end
