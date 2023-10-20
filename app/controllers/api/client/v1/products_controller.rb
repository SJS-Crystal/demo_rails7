class Api::Client::V1::ProductsController < Api::Client::V1::BaseController
  $client_desc << "api/client/v1/products/all | GET | Authorization(header), Device-Id(header), page, items | Get all products from client's admin"
  def all
    products = current_client.admin.products.includes(:brand, :custom_fields).active
    pagy, products = pagy(products, page: params[:page], items: params[:items])
    render_response(object: products, pagy: pagy_metadata(pagy), message: 'success')
  end

  $client_desc << 'api/client/v1/products | GET | Authorization(header), Device-Id(header), page, items | Get only products in view'
  def index
    products = current_client.viewable_products.includes(:brand, :custom_fields).active
    pagy, products = pagy(products, page: params[:page], items: params[:items])
    render_response(object: products, pagy: pagy_metadata(pagy), message: 'success')
  end

  $client_desc << 'api/client/v1/products | PUT | Authorization(header), Device-Id(header), product_id | Add product to view'
  def add_to_view
    current_client.viewable_products << product
    render_response(message: 'success')
  end

  $client_desc << 'api/client/v1/products | PUT | Authorization(header), Device-Id(header), product_id | Remove product from view'
  def remove_from_view
    current_client.viewable_products.delete(product)
    render_response(message: 'success')
  end

  private

  def product
    @product ||= current_client.admin.products.active.find(params[:product_id])
  end
end
