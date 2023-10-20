module ApplicationHelper
  include Pagy::Frontend

  def custom_fields_td(obj, column_num)
    html = []
    obj.custom_fields.each do |cf|
      html << content_tag(:td) do
        content_tag(:b, cf.name) + ": #{cf.value}"
      end
    end

    (column_num - obj.custom_fields.size).times do
      html << content_tag(:td)
    end

    safe_join(html, "\n")
  end

  def custom_fields_th(column_num)
    html = []
    column_num.times do |i|
      html << content_tag(:th) do
        "Custom field #{i + 1}"
      end
    end

    safe_join(html, "\n")
  end

  def notice_classes
    notice_classes = Hash.new(:success)
    notice_classes[:error] = :danger
    notice_classes[:alert] = :info
    notice_classes
  end

  def enum_collection(klass, column)
    klass.send(column.pluralize).keys.map { |key, _| [key.humanize.titleize, key] }
  end

  def order_status_collection
    %w[issued rejected].map { |key| [key.humanize.titleize, key] }
  end

  def brand_collection
    Brand.pluck(:name, :id)
  end

  def currency_collection
    Currency.pluck(:name, :id)
  end

  def badge_status(obj)
    status_map = {
      active: :success,
      inactive: :secondary
    }

    content_tag(:div, class: "badge badge-#{status_map[obj.status.to_sym]} badge-lg") do
      obj.status.humanize.titleize
    end
  end

  def normalize_date_range(start_date, end_date)
    "#{start_date.strftime("%m/%d/%Y")} - #{end_date.strftime("%m/%d/%Y")}"
  end
end
