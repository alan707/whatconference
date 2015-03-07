module BootstrapHelper
  ALERT_CSS_CLASSES = {
    'notice' => 'alert alert-success',
    'alert' => 'alert alert-danger',
    'info' => 'alert alert-info'
  }

  def flash_alert_class(type)
    ALERT_CSS_CLASSES[type.to_s]
  end

  # Use as the options of any *_tag helper like
  # content_tag :span, "Test", tooltip_popup("Help")
  def tooltip_popup(message, direction = :top)
    { :data => { :tooltip => true,
              :placement => direction,
              :container => 'body' },
      :title => message,
    }
  end
end
