class SpendingByTimeService
  def initialize(current_admin, card_conditions, client_ids_for_page, type_time)
    @type_time = type_time
    @current_admin = current_admin
    @card_conditions = card_conditions
    @client_ids_for_page = client_ids_for_page
    @client_total = client_total
    query
  end


  def process_query
    data_matrix = {}
    total_usd_price_per_date = Hash.new(0)
    total_usd_price_per_client = Hash.new(0)

    @query.each do |result|
        date = result.date.to_s if @type_time == 'By day'
        date = "#{result.year.to_i}-#{result.month}" if @type_time == 'By month'
        data_matrix[result.client_id] ||= { name: result.client_name, data: {} }
        data_matrix[result.client_id][:data][date] = result.card_usd_price
        total_usd_price_per_date[date] += result.card_usd_price
        total_usd_price_per_client[result.client_id] = result.client_total_usd_price
    end
    sorted_dates = total_usd_price_per_date.keys.sort


    [data_matrix, total_usd_price_per_date, total_usd_price_per_client, sorted_dates]
  end

  private

  def client_total
    Card.select("client_id, SUM(usd_price) AS client_total_usd_price")
        .where(@card_conditions)
        .group(:client_id)
        .to_sql
  end

  def query
    spending_by_day if @type_time == 'By day'
    spending_by_month if @type_time == 'By month'
  end

  def spending_by_day
    @query = @current_admin.clients.select("clients.id AS client_id,
                                            clients.name AS client_name,
                                            DATE(cards.created_at) AS date,
                                            SUM(cards.usd_price) AS card_usd_price,
                                            client_totals.client_total_usd_price")
                           .joins(:cards)
                           .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
                           .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                           .group("clients.id, clients.name, DATE(cards.created_at), client_totals.client_total_usd_price")
                           .order('client_totals.client_total_usd_price DESC')
  end

  def spending_by_month
    @query = @current_admin.clients.select("clients.id AS client_id,
                                            clients.name AS client_name,
                                            TO_CHAR(cards.created_at, 'YYYY') AS year,
                                            TO_CHAR(cards.created_at, 'MM') AS month,
                                            SUM(cards.usd_price) AS card_usd_price,
                                            client_totals.client_total_usd_price")
                           .joins(:cards)
                           .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
                           .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
                           .group("clients.id, clients.name, TO_CHAR(cards.created_at, 'YYYY'), TO_CHAR(cards.created_at, 'MM'), client_totals.client_total_usd_price")
                           .order('client_totals.client_total_usd_price DESC')
  end
end
