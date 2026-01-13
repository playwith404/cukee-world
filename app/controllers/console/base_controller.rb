module Console
  class BaseController < ApplicationController
    before_action :require_console_authentication
    helper_method :current_enterprise

    private

    def require_console_authentication
      unless current_enterprise
        redirect_to console_login_path, alert: "콘솔에 접근하려면 토큰이 필요합니다."
      end
    end

    def current_enterprise
      @current_enterprise ||= Enterprise.find_by(id: session[:console_enterprise_id])
    end

    def console_logout
      session.delete(:console_enterprise_id)
      session.delete(:console_access_token_id)
    end
  end
end
