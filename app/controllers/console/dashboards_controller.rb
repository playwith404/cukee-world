module Console
  class DashboardsController < BaseController
    def show
      @enterprise = current_enterprise
      @daily_stats = calculate_daily_stats
      @monthly_stats = calculate_monthly_stats
      @recent_activity = @enterprise.api_usages.order(created_at: :desc).limit(10)
      @api_keys_count = @enterprise.api_keys.active.count
    end

    private

    def calculate_daily_stats
      usages = current_enterprise.api_usages.today
      {
        total_calls: usages.count,
        successful: usages.successful.count,
        errors: usages.errors.count,
        error_rate: usages.count.positive? ? (usages.errors.count.to_f / usages.count * 100).round(2) : 0,
        avg_response_time: usages.average(:response_time_ms)&.round(0) || 0
      }
    end

    def calculate_monthly_stats
      usages = current_enterprise.api_usages.this_month
      {
        total_calls: usages.count,
        successful: usages.successful.count,
        errors: usages.errors.count,
        total_cost: usages.sum(:cost),
        top_endpoints: usages.group(:endpoint).count.sort_by { |_, v| -v }.first(5).to_h
      }
    end
  end
end
