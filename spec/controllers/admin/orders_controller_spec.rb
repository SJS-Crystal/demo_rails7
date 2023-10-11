require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  let(:admin) { create(:admin) }
  let(:brand) { create(:brand, admin: admin) }
  let(:product) { create(:product, brand: brand, admin: admin) }
  let(:client) { create(:client, admin: admin) }
  let!(:order) { create(:card, product: product, client: client, admin: admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'lists all orders' do
      get :index
      expect(assigns(:orders)).to include(order)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'shows a specific order' do
      get :show, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    context 'when order is pending approval' do
      before do
        order.update(status: 'pending_approval')
      end

      it 'allows editing the order' do
        get :edit, params: { id: order.id }
        expect(response).to render_template(:edit)
      end
    end

    context 'when order is not pending approval' do
      before do
        order.update(status: 'issued')
      end

      it 'does not allow editing the order' do
        get :edit, params: { id: order.id }
        expect(response).to redirect_to(admin_order_url(order))
        expect(flash[:error]).to eq('Can only modifier pending approval orders')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid status' do
      it 'updates the order' do
        put :update, params: { id: order.id, card: { status: 'rejected' } }
        expect(order.reload.status).to eq('rejected')
        expect(response).to redirect_to(admin_order_url(order))
        expect(flash[:notice]).to eq('Success')
      end
    end

    context 'with invalid status' do
      it 'does not update the order' do
        put :update, params: { id: order.id, card: { status: 'invalid_status' } }
        expect(response).to render_template(:edit)
        expect(flash[:danger]).to eq('Invalid status')
      end
    end
  end
end
