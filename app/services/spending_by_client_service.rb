class SpendingByClientService
  def initialize(current_admin, card_conditions, client_ids_for_page)
    @client_total = client_total(card_conditions)
    @query = query(current_admin, card_conditions, client_ids_for_page)
  end

  def process_query
    rows = {}
    all_products = {}

    total_usd_price_per_product = Hash.new(0)

    @query.each do |record|
      product_id = record.product_id
      client_id = record.client_id
      product_name = record.product_name
      client_name = record.client_name
      client_total_usd_price = record.client_total_usd_price
      total_usd_price = record.total_usd_price
      total_usd_price_per_product[product_id] += total_usd_price
      total_usd_price_per_product[:total_product] += client_total_usd_price
      rows[client_id] ||= { client_name: client_name, client_total_usd_price: client_total_usd_price, products: {} }
      rows[client_id][:products][product_id] = { product_name: product_name, total_usd_price: total_usd_price }
      all_products[product_id] = product_name
    end

    all_products = all_products.sort_by { |_id, name| name }.to_h
    [rows, all_products, total_usd_price_per_product]
  end

  private

  def client_total(card_conditions)
    Card.select("client_id, SUM(usd_price) AS client_total_usd_price")
        .where(card_conditions)
        .group(:client_id)
        .to_sql
  end

  def query(current_admin, card_conditions, client_ids_for_page)
    current_admin.clients.select("clients.id AS client_id,
                                  clients.name AS client_name,
                                  products.id AS product_id,
                                  products.name AS product_name,
                                  SUM(cards.usd_price) AS total_usd_price,
                                  client_totals.client_total_usd_price")
                  .joins("CROSS JOIN products")
                  .joins("LEFT JOIN cards ON products.id = cards.product_id AND clients.id = cards.client_id")
                  .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
                  .where(clients: {id: client_ids_for_page}, cards: card_conditions)
                  .group("clients.id, products.id, clients.name, products.name, client_totals.client_total_usd_price")
                  .order("client_totals.client_total_usd_price DESC")
  end
end
