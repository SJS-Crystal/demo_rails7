class Api::Client::V1::CardsController < Api::Client::V1::BaseController
  before_action :set_card, only: [:show, :cancel]

  $client_desc << 'api/client/v1/cards | POST | Authorization(header), Device-Id(header), product_id | Request new card'
  def create
    product = current_client.admin.products.active.find(params[:product_id])
    card = Card.create!(
      product: product,
      client: current_client,
      price: product.price,
      currency: product.currency_name
    )

    render_response(object: card, message: 'Card requested successfully')
  end

  $client_desc << 'api/client/v1/cards | GET | Authorization(header), Device-Id(header), page, items | Get all cards of the client'
  def index
    cards = current_client.cards
    pagy, cards = pagy(cards, page: params[:page], items: params[:items])
    render_response(object: cards, pagy: pagy_metadata(pagy), message: 'success')
  end

  $client_desc << 'api/client/v1/cards/:id | GET | Authorization(header), Device-Id(header) | Get detail of a specific card'
  def show
    render_response(object: @card, message: 'success')
  end

  $client_desc << 'api/client/v1/cards/:id/cancel | PUT | Authorization(header), Device-Id(header) | Cancel a card'
  def cancel
    return render_response(status: 422, message: 'Can only cancel issued card') unless @card.issued?

    @card.canceled!
    render_response(object: @card, message: 'Card canceled successfully')
  end

  $client_desc << 'api/client/v1/cards/activate | PUT | Authorization(header), Device-Id(header), activation_code | Activate a card'
  def activate
    card = current_client.cards.find_by(activation_code: params[:activation_code])

    return render_response(status: 401, message: 'Activation code is incorrect') unless card
    return render_response(status: 422, message: 'Can only activate issued card') unless card.issued?

    card.active!
    render_response(object: card, message: 'Card activated successfully')
  end

  private

  def set_card
    @card = current_client.cards.find(params[:id])
  end
end
