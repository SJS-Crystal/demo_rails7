class Admin::ReportsController < Admin::BaseController
  before_action :set_condition
  before_action :set_type_time, only: [:cards_by_time, :spending_by_time]

  def cards_by_client_product
    @client_ids_for_page = fetch_client_ids.order('COUNT(cards.id) DESC')
    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)
    @rows, @all_products, @total_card_per_product = CardByClientService.new(current_admin, @card_conditions, @client_ids_for_page).process_query
  end

  def spending_by_client_product
    @client_ids_for_page = fetch_client_ids.order('SUM(cards.usd_price) DESC')
    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)
    @rows, @all_products, @total_usd_price_per_product = SpendingByClientService.new(current_admin, @card_conditions, @client_ids_for_page).process_query
  end

  def cards_by_time
    @client_ids_for_page = fetch_client_ids.order('COUNT(cards.id) DESC')
    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)
    card_by_time_object = CardByTimeService.new(current_admin, @card_conditions, @client_ids_for_page, @type_time)
    @data_matrix, @total_cards_per_date, @total_cards_per_client, @sorted_dates = card_by_time_object.process_query
  end

  def spending_by_time
    @client_ids_for_page = fetch_client_ids.order('SUM(cards.usd_price) DESC')
    @pagy, @client_ids_for_page = pagy(@client_ids_for_page)
    card_by_time_object = SpendingByTimeService.new(current_admin, @card_conditions, @client_ids_for_page, @type_time)
    @data_matrix, @total_usd_price_per_date, @total_usd_price_per_client, @sorted_dates = card_by_time_object.process_query
  end

  private

  def set_condition
    if params[:date_range].present?
      date_range = params[:date_range].split(' - ')
      @start_date = DateTime.strptime(date_range[0], '%m/%d/%Y')
      @end_date = DateTime.strptime(date_range[1], '%m/%d/%Y')
    end
    @start_date ||= Time.zone.now.at_beginning_of_month
    @end_date ||= Time.zone.now
    @card_conditions = {status: params[:card_status].presence, created_at: @start_date..@end_date, admin_id: current_admin}.compact
  end

  def set_type_time
    @type_time = (params[:by_time] == 'By month') ? 'By month' : 'By day'
  end

  def fetch_client_ids
    current_admin.clients.select(:id)
      .left_joins(:cards)
      .where(cards: @card_conditions)
      .group('clients.id')
  end
end
