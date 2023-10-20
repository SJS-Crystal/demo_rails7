class CardByClientService
  def initialize(current_admin, card_conditions, client_ids_for_page)
    @client_total = client_total(card_conditions)
    @query = query(current_admin, card_conditions, client_ids_for_page)
  end

  def process_query
    rows = {}
    all_products = {}
    total_card_per_product = Hash.new(0)

    @query.each do |record|
      product_id = record.product_id
      client_id = record.client_id
      product_name = record.product_name
      client_name = record.client_name
      client_card_count = record.client_card_count
      card_count = record.card_count
      total_card_per_product[product_id] += card_count
      total_card_per_product[:total_product] += client_card_count

      rows[client_id] ||= {client_name: client_name, client_card_count: client_card_count, products: {}}
      rows[client_id][:products][product_id] = {product_name: product_name, card_count: card_count}

      all_products[product_id] = product_name
    end

    all_products = all_products.sort_by { |_id, name| name }.to_h
    [rows, all_products, total_card_per_product]
  end

  private

  def client_total(card_conditions)
    Card.select('client_id, COUNT(*) AS client_card_count')
      .where(card_conditions)
      .group(:client_id)
      .to_sql
  end

  def query(current_admin, card_conditions, client_ids_for_page)
    current_admin.clients.select("clients.id AS client_id,
                                  clients.name AS client_name,
                                  products.id AS product_id,
                                  products.name AS product_name,
                                  COUNT(cards.id) AS card_count,
                                  client_totals.client_card_count")
      .joins('CROSS JOIN products')
      .joins('LEFT JOIN cards ON products.id = cards.product_id AND clients.id = cards.client_id')
      .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
      .where(clients: {id: client_ids_for_page}, cards: card_conditions)
      .group('clients.id, products.id, clients.name, products.name, client_totals.client_card_count')
      .order('client_totals.client_card_count DESC')
  end
end
