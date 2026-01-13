class AlertSetting < ApplicationRecord
  belongs_to :enterprise

  validates :usage_threshold_percent,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 },
            allow_nil: true
  validates :error_rate_threshold,
            numericality: { greater_than: 0, less_than_or_equal_to: 100 },
            allow_nil: true
  validates :billing_threshold,
            numericality: { greater_than: 0 },
            allow_nil: true
  validates :notification_email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            allow_blank: true
  validates :slack_webhook_url,
            format: { with: /\Ahttps:\/\/hooks\.slack\.com\// },
            allow_blank: true

  def any_alert_enabled?
    usage_threshold_enabled || error_rate_enabled || billing_alert_enabled || security_alert_enabled
  end
end
