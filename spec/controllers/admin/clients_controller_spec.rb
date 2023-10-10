# spec/controllers/admin/clients_controller_spec.rb
require 'rails_helper'

RSpec.describe Admin::ClientsController, type: :controller do
  let(:admin) { FactoryBot.create(:admin) }
  let(:client1) { FactoryBot.create(:client, admin_id: admin.id) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @clients' do
      client = client1
      get :index
      expect(assigns(:clients)).to eq([client])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'assigns @client' do
      client = client1
      get :show, params: { id: client.id }
      expect(assigns(:client)).to eq(client)
    end

    it 'renders the show template' do
      client = client1
      get :show, params: { id: client.id }
      expect(response).to render_template('show')
    end
  end

  describe 'GET #new' do
    it 'assigns a new client as @client' do
      get :new
      expect(assigns(:client)).to be_a_new(Client)
    end
  end

  describe 'GET #edit' do
    it 'assigns @client' do
      client = client1
      get :edit, params: { id: client.id }
      expect(assigns(:client)).to eq(client)
    end

    it 'renders the edit template' do
      client = client1
      get :edit, params: { id: client.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Client' do
        valid_params = FactoryBot.attributes_for(:client)
        expect do
          post :create, params: { client: valid_params }
        end.to change(Client, :count).by(1)
      end

      it 'assigns a newly created client as @client' do
        valid_params = FactoryBot.attributes_for(:client)
        post :create, params: { client: valid_params }
        expect(assigns(:client)).to be_a(Client)
        expect(assigns(:client)).to be_persisted
      end

      it 'redirects to the created client' do
        valid_params = FactoryBot.attributes_for(:client)
        post :create, params: { client: valid_params }
        expect(response).to redirect_to(admin_clients_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved client as @client' do
        invalid_params = FactoryBot.attributes_for(:client, username: nil)
        post :create, params: { client: invalid_params }
        expect(assigns(:client)).to be_a_new(Client)
      end

      it 're-renders the new template' do
        invalid_params = FactoryBot.attributes_for(:client, username: nil)
        post :create, params: { client: invalid_params }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested client' do
        client = client1
        valid_params = { username: 'newusername' }
        put :update, params: { id: client.id, client: valid_params }
        expect(client.reload.username).to eq('newusername')
      end

      it 'assigns the requested client as @client' do
        client = client1
        valid_params = FactoryBot.attributes_for(:client)
        put :update, params: { id: client.id, client: valid_params }
        expect(assigns(:client)).to eq(client)
      end

      it 'redirects to the client' do
        client = client1
        valid_params = FactoryBot.attributes_for(:client)
        put :update, params: { id: client.id, client: valid_params }
        expect(response).to redirect_to(admin_client_url(client))
      end
    end

    context 'with invalid params' do
      it 'assigns the client as @client' do
        client = client1
        invalid_params = FactoryBot.attributes_for(:client, username: nil)
        put :update, params: { id: client.id, client: invalid_params }
        expect(assigns(:client)).to eq(client)
      end

      it 're-renders the edit template' do
        client = client1
        invalid_params = FactoryBot.attributes_for(:client, username: nil)
        put :update, params: { id: client.id, client: invalid_params }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested client' do
      client = client1
      expect do
        delete :destroy, params: { id: client.id }
      end.to change(Client, :count).by(-1)
    end

    it 'redirects to the clients list' do
      client = client1
      delete :destroy, params: { id: client.id }
      expect(response).to redirect_to(admin_clients_url)
    end
  end
end
