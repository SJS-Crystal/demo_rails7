module OrderHelper
  def order_status(order)
    status_map = {
      pending_approval: :warning,
      issued: :info,
      active: :success,
      canceled: :secondary,
      rejected: :danger
    }

    badge_tag =  content_tag(:div, class: "badge badge-#{status_map[order.status.to_sym]} badge-lg") do
      order.status.humanize.titleize
    end
    raw(badge_tag)
  end
end
