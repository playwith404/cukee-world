class CreateAlertSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :alert_settings do |t|
      t.references :enterprise, null: false, foreign_key: true, index: { unique: true }
      t.boolean :usage_threshold_enabled, default: true
      t.integer :usage_threshold_percent, default: 80
      t.boolean :error_rate_enabled, default: true
      t.decimal :error_rate_threshold, precision: 5, scale: 2, default: 5.0
      t.boolean :billing_alert_enabled, default: true
      t.decimal :billing_threshold, precision: 10, scale: 2, default: 100000.0
      t.boolean :security_alert_enabled, default: true
      t.string :notification_email
      t.boolean :slack_enabled, default: false
      t.string :slack_webhook_url

      t.timestamps
    end
  end
end
