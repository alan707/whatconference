module BootstrapHelper
  ALERT_CSS_CLASSES = {
    'notice' => 'alert alert-success',
    'alert' => 'alert alert-danger',
    'info' => 'alert alert-info'
  }

  def flash_alert_class(type)
    type = type.to_s
    ALERT_CSS_CLASSES[type]
  end

end
