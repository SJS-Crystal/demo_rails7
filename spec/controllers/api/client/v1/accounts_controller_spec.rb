require 'rails_helper'

RSpec.describe Api::Client::V1::AccountsController, type: :controller do
  let!(:device) { create(:device) }
  let!(:client) { create(:client, password: 'password123', password_confirmation: 'password123') }
  let!(:jwt) { JwtService.generate_jwt_token(client.id, device.device_id, device.secret) }

  describe '#update' do
    it 'updates the client successfully' do
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      put :update, params: { name: 'New Name', password: 'newpassword123', password_confirmation: 'newpassword123' }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data']['name']).to eq 'New Name'
    end

    it 'fails to update the client' do
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      put :update, params: { name: '', password: 'newpassword123', password_confirmation: 'newpassword123' }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['success']).to be false
    end
  end

  describe '#profile' do
    it 'returns the client profile' do
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      get :profile

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data']['id']).to eq client.id
    end
  end

  describe '#login' do
    it 'logs in successfully' do
      request.headers['Device-Id'] = device.device_id
      post :login, params: { username: client.username, password: 'password123' }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data']['access_token']).not_to be_nil
    end

    it 'fails to log in due to incorrect credentials' do
      request.headers['Device-Id'] = device.device_id
      post :login, params: { username: client.username, password: 'wrongpassword' }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['success']).to be false
    end
  end

  describe '#logout' do
    it 'logs out successfully' do
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      delete :logout

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'Logout successfully!'
    end
  end
end
