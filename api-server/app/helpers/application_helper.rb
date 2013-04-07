module ApplicationHelper
  def alert_box(message, options = {})
    classes = %w(alert alert-block)
    classes << "alert-#{options[:context]}" if options[:context].present?
    content_tag(:div, class: classes.join(' ')) do
      out = []
      out << button_tag(raw('&times;'), type: :button, class: 'close', data: {dismiss: 'alert'})
      out << message
      safe_join(out)
    end
  end
end
