module Console
  class AlertsController < BaseController
    def index
      @alert_setting = current_enterprise.alert_setting || current_enterprise.create_alert_setting
    end

    def update
      @alert_setting = current_enterprise.alert_setting

      if @alert_setting.update(alert_setting_params)
        redirect_to console_alerts_path, notice: "알림 설정이 저장되었습니다."
      else
        flash.now[:alert] = "설정 저장에 실패했습니다: #{@alert_setting.errors.full_messages.join(', ')}"
        render :index, status: :unprocessable_entity
      end
    end

    private

    def alert_setting_params
      params.require(:alert_setting).permit(
        :usage_threshold_enabled, :usage_threshold_percent,
        :error_rate_enabled, :error_rate_threshold,
        :billing_alert_enabled, :billing_threshold,
        :security_alert_enabled, :notification_email,
        :slack_enabled, :slack_webhook_url
      )
    end
  end
end
