class Admin::ReportsController < Admin::BaseController
  before_action :set_condition
  before_action :set_type_time, only: [:cards_by_time, :spending_by_time]

  def cards_by_client_product
    @client_ids_for_page = current_admin.clients.select(:id)
                                  .joins('LEFT JOIN cards ON clients.id = cards.client_id')
                                  .where(cards: @card_conditions)
                                  .group('clients.id')
                                  .order('COUNT(cards.id) DESC')

    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)

    total_by_clients = Card.select("client_id, COUNT(*) AS client_card_count")
                                  .where(@card_conditions)
                                  .group(:client_id)
                                  .to_sql

    query = current_admin.clients.select("clients.id AS client_id,
                          clients.name AS client_name,
                          products.id AS product_id,
                          products.name AS product_name,
                          COUNT(cards.id) AS card_count,
                          client_totals.client_card_count")
                  .joins("CROSS JOIN products")
                  .joins("LEFT JOIN cards ON products.id = cards.product_id AND clients.id = cards.client_id")
                  .joins("LEFT JOIN (#{total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                  .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                  .group("clients.id, products.id, clients.name, products.name, client_totals.client_card_count")
                  .order("client_totals.client_card_count DESC")

    @rows = {}
    @all_products = {}
    @total_card_per_product = Hash.new(0)

    query.each do |record|
      product_id = record.product_id
      client_id = record.client_id
      product_name = record.product_name
      client_name = record.client_name
      client_card_count = record.client_card_count
      card_count = record.card_count
      @total_card_per_product[product_id] += card_count
      @total_card_per_product[:total_product] += client_card_count

      @rows[client_id] ||= { client_name: client_name, client_card_count: client_card_count, products: {} }
      @rows[client_id][:products][product_id] = { product_name: product_name, card_count: card_count }

      @all_products[product_id] = product_name
    end

    @all_products = @all_products.sort_by { |_id, name| name }.to_h
  end

  def spending_by_client_product
    @client_ids_for_page = current_admin.clients.select(:id)
                                  .joins('LEFT JOIN cards ON clients.id = cards.client_id')
                                  .where(cards: @card_conditions)
                                  .group('clients.id')
                                  .order('SUM(cards.usd_price) DESC')

    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)

    total_by_clients = Card.select("client_id, SUM(usd_price) AS client_total_usd_price")
                                  .where(@card_conditions)
                                  .group(:client_id)
                                  .to_sql

    query = current_admin.clients.select("clients.id AS client_id,
                          clients.name AS client_name,
                          products.id AS product_id,
                          products.name AS product_name,
                          SUM(cards.usd_price) AS total_usd_price,
                          client_totals.client_total_usd_price")
                  .joins("CROSS JOIN products")
                  .joins("LEFT JOIN cards ON products.id = cards.product_id AND clients.id = cards.client_id")
                  .joins("LEFT JOIN (#{total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                  .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                  .group("clients.id, products.id, clients.name, products.name, client_totals.client_total_usd_price")
                  .order("client_totals.client_total_usd_price DESC")

    @rows = {}
    @all_products = {}

    @total_usd_price_per_product = Hash.new(0)

    query.each do |record|
      product_id = record.product_id
      client_id = record.client_id
      product_name = record.product_name
      client_name = record.client_name
      client_total_usd_price = record.client_total_usd_price
      total_usd_price = record.total_usd_price
      @total_usd_price_per_product[product_id] += total_usd_price
      @total_usd_price_per_product[:total_product] += client_total_usd_price
      @rows[client_id] ||= { client_name: client_name, client_total_usd_price: client_total_usd_price, products: {} }
      @rows[client_id][:products][product_id] = { product_name: product_name, total_usd_price: total_usd_price }
      @all_products[product_id] = product_name
    end

    @all_products = @all_products.sort_by { |_id, name| name }.to_h
  end

  def cards_by_time
    @client_ids_for_page = current_admin.clients.select(:id)
                                .joins('LEFT JOIN cards ON clients.id = cards.client_id')
                                .where(cards: @card_conditions)
                                .group('clients.id')
                                .order('COUNT(cards.id) DESC')

    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)

    @total_by_clients = Card.select("client_id, COUNT(*) AS client_card_count")
                                 .where(@card_conditions)
                                 .group(:client_id)
                                 .to_sql

    cards_by_day if @type_time == 'By day'
    cards_by_month if @type_time == 'By month'

    @data_matrix = {}
    @total_cards_per_date = Hash.new(0)
    @total_cards_per_client = Hash.new(0)

    @query_results.each do |result|
      date = result.date.to_s if @type_time == 'By day'
      date = "#{result.year.to_i}-#{result.month.to_i}" if @type_time == 'By month'
      @data_matrix[result.client_id] ||= { name: result.client_name, data: {} }
      @data_matrix[result.client_id][:data][date] = result.card_count

      @total_cards_per_date[date] += result.card_count
      @total_cards_per_client[result.client_id] += result.card_count
    end

    @sorted_dates = @total_cards_per_date.keys.sort
  end

  def spending_by_time
    @client_ids_for_page = current_admin.clients.select(:id)
                                .joins('LEFT JOIN cards ON clients.id = cards.client_id')
                                .where(cards: @card_conditions)
                                .group('clients.id')
                                .order('SUM(cards.usd_price) DESC')

    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)

    @total_by_clients = Card.select("client_id, SUM(usd_price) AS client_total_usd_price")
                                  .where(@card_conditions)
                                  .group(:client_id)
                                  .to_sql

    spending_by_day if @type_time == 'By day'
    spending_by_month if @type_time == 'By month'

    @data_matrix = {}
    @total_usd_price_per_date = Hash.new(0)
    @total_usd_price_per_client = Hash.new(0)

    @query_results.each do |result|
        date = result.date.to_s if @type_time == 'By day'
        date = "#{result.year.to_i}-#{result.month}" if @type_time == 'By month'
        @data_matrix[result.client_id] ||= { name: result.client_name, data: {} }
        @data_matrix[result.client_id][:data][date] = result.card_usd_price
        @total_usd_price_per_date[date] += result.card_usd_price
        @total_usd_price_per_client[result.client_id] = result.client_total_usd_price
    end

    @sorted_dates = @total_usd_price_per_date.keys.sort
  end

  private

  def cards_by_day
    @query_results = current_admin.clients.select("clients.id AS client_id,
                                    clients.name AS client_name,
                                    DATE(cards.created_at) AS date,
                                    COUNT(cards.id) AS card_count")
                           .joins("LEFT JOIN cards ON clients.id = cards.client_id")
                           .joins("LEFT JOIN (#{@total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                           .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                           .group("clients.id, clients.name, DATE(cards.created_at), client_totals.client_card_count")
                           .order("client_totals.client_card_count DESC, DATE(cards.created_at)")
  end

  def cards_by_month
    @query_results = current_admin.clients.select("clients.id AS client_id,
                                    clients.name AS client_name,
                                    EXTRACT(YEAR FROM cards.created_at) AS year,
                                    EXTRACT(MONTH FROM cards.created_at) AS month,
                                    COUNT(cards.id) AS card_count")
                           .joins('LEFT JOIN cards ON clients.id = cards.client_id')
                           .joins("LEFT JOIN (#{@total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                           .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                           .group("clients.id, clients.name, #{Arel.sql('EXTRACT(YEAR FROM cards.created_at), EXTRACT(MONTH FROM cards.created_at)')}, client_totals.client_card_count")
                           .order('client_totals.client_card_count DESC, year DESC, month DESC')
  end

  def spending_by_day
    @query_results = current_admin.clients.select("clients.id AS client_id,
                                    clients.name AS client_name,
                                    DATE(cards.created_at) AS date,
                                    SUM(cards.usd_price) AS card_usd_price,
                                    client_totals.client_total_usd_price")
                            .joins(:cards)
                            .joins("LEFT JOIN (#{@total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                            .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                            .group("clients.id, clients.name, DATE(cards.created_at), client_totals.client_total_usd_price")
                            .order('client_totals.client_total_usd_price DESC')
  end

  def spending_by_month
    @query_results = current_admin.clients.select("clients.id AS client_id,
                                    clients.name AS client_name,
                                    TO_CHAR(cards.created_at, 'YYYY') AS year,
                                    TO_CHAR(cards.created_at, 'MM') AS month,
                                    SUM(cards.usd_price) AS card_usd_price,
                                    client_totals.client_total_usd_price")
                            .joins(:cards)
                            .joins("LEFT JOIN (#{@total_by_clients}) AS client_totals ON clients.id = client_totals.client_id")
                            .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                            .group("clients.id, clients.name, TO_CHAR(cards.created_at, 'YYYY'), TO_CHAR(cards.created_at, 'MM'), client_totals.client_total_usd_price")
                            .order('client_totals.client_total_usd_price DESC')
  end

  def set_condition
    if params[:date_range].present?
      date_range = params[:date_range].split(" - ")
      @start_date = DateTime.strptime(date_range[0], "%m/%d/%Y")
      @end_date = DateTime.strptime(date_range[1], "%m/%d/%Y")
    end
    @start_date ||=  Time.zone.now.at_beginning_of_month
    @end_date ||= Time.zone.now
    @card_conditions = { status: params[:card_status].presence, created_at: @start_date..@end_date, admin_id: current_admin }.compact
  end

  def set_type_time
    @type_time = params[:by_time] == 'By month' ? 'By month' : 'By day'
  end
end
