module ApplicationHelper
  def notice_classes
    notice_classes = Hash.new(:success)
    notice_classes[:error] = :danger
    notice_classes[:alert] = :info
    notice_classes
  end
end
