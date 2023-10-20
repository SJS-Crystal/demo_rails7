class CardByTimeService
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
    total_cards_per_date = Hash.new(0)
    total_cards_per_client = Hash.new(0)

    @query.each do |result|
      date = result.date.to_s if @type_time == 'By day'
      date = "#{result.year.to_i}-#{result.month.to_i}" if @type_time == 'By month'
      data_matrix[result.client_id] ||= {name: result.client_name, data: {}}
      data_matrix[result.client_id][:data][date] = result.card_count

      total_cards_per_date[date] += result.card_count
      total_cards_per_client[result.client_id] += result.card_count
    end
    sorted_dates = total_cards_per_date.keys.sort

    [data_matrix, total_cards_per_date, total_cards_per_client, sorted_dates]
  end

  private

  def client_total
    Card.select('client_id, COUNT(*) AS client_card_count')
      .where(@card_conditions)
      .group(:client_id)
      .to_sql
  end

  def query
    cards_by_day if @type_time == 'By day'
    cards_by_month if @type_time == 'By month'
  end

  def cards_by_day
    @query = @current_admin.clients.select("clients.id AS client_id,
                                           clients.name AS client_name,
                                           DATE(cards.created_at) AS date,
                                           COUNT(cards.id) AS card_count")
      .joins('LEFT JOIN cards ON clients.id = cards.client_id')
      .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
      .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
      .group('clients.id, clients.name, DATE(cards.created_at), client_totals.client_card_count')
      .order('client_totals.client_card_count DESC, DATE(cards.created_at)')
  end

  def cards_by_month
    @query = @current_admin.clients.select("clients.id AS client_id,
                                           clients.name AS client_name,
                                           TO_CHAR(cards.created_at, 'YYYY') AS year,
                                           TO_CHAR(cards.created_at, 'MM') AS month,
                                           COUNT(cards.id) AS card_count")
      .joins('LEFT JOIN cards ON clients.id = cards.client_id')
      .joins("LEFT JOIN (#{@client_total}) AS client_totals ON clients.id = client_totals.client_id")
      .where(clients: {id: @client_ids_for_page}, cards: @card_conditions)
      .group("clients.id, clients.name, TO_CHAR(cards.created_at, 'YYYY'), TO_CHAR(cards.created_at, 'MM'), client_totals.client_card_count")
      .order('client_totals.client_card_count DESC, year DESC, month DESC')
  end
end
