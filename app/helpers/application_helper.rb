module ApplicationHelper
  include Pagy::Frontend

  def custom_fields_td(obj, column_num)
    html = ''
    obj.custom_fields.each do |cf|
      html << content_tag(:td) do
        content_tag(:b, cf.name) + ": #{cf.value}"
      end
    end

    (column_num - obj.custom_fields.size).times do
      html << content_tag(:td)
    end

    raw(html)
  end

  def custom_fields_th(column_num)
    html = ''
    column_num.times do |i|
      html << content_tag(:th) do
        "Custom field #{i + 1}"
      end
    end

    raw(html)
  end

  def notice_classes
    notice_classes = Hash.new(:success)
    notice_classes[:error] = :danger
    notice_classes[:alert] = :info
    notice_classes
  end

  def enum_collection(klass, column)
    klass.send(column.pluralize).keys.map { |key, _| [key.capitalize, key] }
  end

  def brand_collection
    Brand.pluck(:name, :id)
  end

  def currency_collection
    Currency.pluck(:name, :id)
  end
end
