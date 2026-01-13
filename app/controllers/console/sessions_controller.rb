module Console
  class SessionsController < ApplicationController
    layout "application"

    def new
      redirect_to console_dashboard_path if current_enterprise
    end

    def create
      token = params[:access_token]&.strip

      if token.present? && authenticate_with_token(token)
        redirect_to console_dashboard_path, notice: "콘솔에 로그인되었습니다."
      else
        flash.now[:alert] = "유효하지 않은 토큰입니다. 다시 확인해 주세요."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      console_logout
      redirect_to console_login_path, notice: "로그아웃되었습니다."
    end

    private

    def current_enterprise
      @current_enterprise ||= Enterprise.find_by(id: session[:console_enterprise_id])
    end

    def authenticate_with_token(token)
      access_token = AccessToken.authenticate(token)

      if access_token&.enterprise&.active?
        session[:console_enterprise_id] = access_token.enterprise.id
        session[:console_access_token_id] = access_token.id
        true
      else
        false
      end
    end

    def console_logout
      session.delete(:console_enterprise_id)
      session.delete(:console_access_token_id)
    end
  end
end
