class Api::Client::V1::DocumentController < ActionController::Base
  def index
    Api::Client::V1::AccountsController.new
    Api::Client::V1::ProductsController.new

    render template: 'layouts/api_documents/client', layout: false
  end
end
