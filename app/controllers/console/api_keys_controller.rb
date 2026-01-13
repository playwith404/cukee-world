module Console
  class ApiKeysController < BaseController
    before_action :set_api_key, only: [ :destroy, :revoke ]

    def index
      @api_keys = current_enterprise.api_keys.order(created_at: :desc)
      @new_api_key = current_enterprise.api_keys.build
    end

    def create
      @api_key = current_enterprise.api_keys.build(api_key_params)

      if @api_key.save
        flash[:notice] = "API 키가 생성되었습니다."
        flash[:new_api_key] = @api_key.raw_key
        redirect_to console_api_keys_path
      else
        flash[:alert] = "API 키 생성에 실패했습니다: #{@api_key.errors.full_messages.join(', ')}"
        redirect_to console_api_keys_path
      end
    end

    def revoke
      @api_key.revoke!
      redirect_to console_api_keys_path, notice: "API 키가 비활성화되었습니다."
    end

    def destroy
      @api_key.destroy
      redirect_to console_api_keys_path, notice: "API 키가 삭제되었습니다."
    end

    private

    def set_api_key
      @api_key = current_enterprise.api_keys.find(params[:id])
    end

    def api_key_params
      params.require(:api_key).permit(:name, :environment, :allowed_ips, :allowed_origins)
    end
  end
end
