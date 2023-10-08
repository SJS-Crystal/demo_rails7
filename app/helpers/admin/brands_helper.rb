module Admin::BrandsHelper
  def custom_fields_td(brand)
    html = ''
    brand.custom_fields.each do |cf|
      html << content_tag(:td) do
        content_tag(:b, cf.name) + ": #{cf.value}"
      end
    end

    (Settings.max_brand_custom_field - brand.custom_fields.size).times do
      html << content_tag(:td)
    end

    raw(html)
  end

  def custom_fields_th
    html = ''
    Settings.max_brand_custom_field.times do |i|
      html << content_tag(:td) do
        "Custom field #{i + 1}"
      end
    end

    raw(html)
  end
end
