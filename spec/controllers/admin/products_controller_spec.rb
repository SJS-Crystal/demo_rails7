require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:currency) { create(:currency) }
  let(:product) { create(:product, admin: admin, currency: currency.name) }
  let(:brand) { create(:brand, admin: admin) }
  let(:valid_attributes) { { name: 'New Product 1', status: 'active', admin_id: admin.id, price: '2', brand_id: brand.id, stock: 33 } }
  let(:invalid_attributes) { { name: nil, status: nil } }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns all products as @products' do
      get :index
      expect(assigns(:products)).to eq([product])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested product as @product' do
      get :show, params: { id: product.to_param }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'GET #new' do
    it 'assigns a new product as @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested product as @product' do
      get :edit, params: { id: product.to_param }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect {
          post :create, params: { product: valid_attributes, currency_id: currency.id }
        }.to change(Product, :count).by(1)
      end

      it 'assigns a newly created product as @product' do
        post :create, params: { product: valid_attributes, currency_id: currency.id }
        expect(assigns(:product)).to be_a(Product)
        expect(assigns(:product)).to be_persisted
      end

      it 'redirects to the created product' do
        post :create, params: { product: valid_attributes, currency_id: currency.id }
        expect(response).to redirect_to(admin_products_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved product as @product' do
        post :create, params: { product: invalid_attributes }
        expect(assigns(:product)).to be_a_new(Product)
      end

      it "re-renders the 'new' template" do
        post :create, params: { product: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Product' } }

      it 'updates the requested product' do
        put :update, params: { id: product.to_param, product: new_attributes, currency_id: currency.id }
        product.reload
        expect(product.name).to eq('Updated Product')
      end

      it 'assigns the requested product as @product' do
        put :update, params: { id: product.to_param, product: valid_attributes, currency_id: currency.id }
        expect(assigns(:product)).to eq(product)
      end

      it 'redirects to the product' do
        put :update, params: { id: product.to_param, product: valid_attributes, currency_id: currency.id }
        expect(response).to redirect_to([:admin, product])
      end
    end

    context 'with invalid params' do
      it 'assigns the product as @product' do
        put :update, params: { id: product.to_param, product: invalid_attributes }
        expect(assigns(:product)).to eq(product)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: product.to_param, product: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product
      expect {
        delete :destroy, params: { id: product.to_param }
      }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      delete :destroy, params: { id: product.to_param }
      expect(response).to redirect_to(admin_products_url)
    end
  end
end
