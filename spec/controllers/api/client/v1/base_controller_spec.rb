require 'rails_helper'

RSpec.describe Api::Client::V1::BaseController, type: :controller do
  let!(:client) { create(:client) }
  let!(:device) { create(:device, client: client) }
  let!(:jwt) { JwtService.generate_jwt_token(client.id, device.device_id, device.secret) }

  controller(Api::Client::V1::BaseController) do
    def index
      render_response(object: Client.last)
    end

    def pagy_metadata_test
      @pagy, clients = pagy(Client.all, items: 1)
      render_response(object: clients, message: pagy_metadata(@pagy).to_json)
    end
  end

  before do
    routes.draw { get 'index' => 'api/client/v1/base#index' }
  end

  describe '#authenticate_client!' do
    context 'when device does not exist' do
      it 'returns a 401 error' do
        request.headers['Authorization'] = "Bearer #{jwt}"
        request.headers['Device-Id'] = 'nonexistent_device'
        get :index
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['message']).to eq 'Device_id is invalid!'
      end
    end

    context 'when jwt is invalid' do
      it 'returns a 401 error' do
        request.headers['Authorization'] = "Bearer invalid_token"
        request.headers['Device-Id'] = device.device_id
        get :index
        expect(response.status).to eq 401
      end
    end
  end

  describe '#current_client' do
    context 'when device and jwt token are invalid' do
      it 'sets nil' do
        request.headers['Authorization'] = "Bearer invalid_token"
        request.headers['Device-Id'] = device.device_id
        get :index

        expect(assigns(:current_client)).to eq nil
      end
    end

    context 'when device does not exist' do
      it 'sets nil' do
        request.headers['Authorization'] = "Bearer #{jwt}"
        request.headers['Device-Id'] = 'nonexistent_device'
        get :index

        expect(assigns(:current_client)).to eq nil
      end
    end

    context 'when device and jwt token are valid' do
      it 'sets @current_client' do
        request.headers['Authorization'] = "Bearer #{jwt}"
        request.headers['Device-Id'] = device.device_id
        get :index
        expect(assigns(:current_client)).to eq client
      end
    end
  end

  describe '#render_response' do
    it 'renders the correct response' do
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      get :index

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data']['id']).to eq client.id
    end
  end

  describe '#pagy_metadata' do
    before do
      routes.draw { get 'pagy_metadata_test' => 'api/client/v1/base#pagy_metadata_test' }
    end

    it 'returns the correct pagy metadata' do
      create_list(:client, 10)
      request.headers['Authorization'] = "Bearer #{jwt}"
      request.headers['Device-Id'] = device.device_id
      get :pagy_metadata_test

      metadata = JSON.parse(response.body)['message']
      expect(response.status).to eq 200
      expect(metadata).to eq({
        "current_page" => 1,
        "next_page" => 2,
        "prev_page" => nil,
        "total_pages" => 11, # 11 because 1 client is acreated when creating jwt token
        "total_count" => 11
      }.to_json)
    end
  end
end
