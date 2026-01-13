module Console
  class BillingController < BaseController
    def index
      @enterprise = current_enterprise
      @current_period = calculate_current_period
      @usage_breakdown = calculate_usage_breakdown
      @estimated_cost = calculate_estimated_cost
      @billing_history = generate_billing_history
    end

    private

    def calculate_current_period
      start_date = @enterprise.billing_cycle_start || Date.current.beginning_of_month
      {
        start_date: start_date,
        end_date: start_date + 1.month - 1.day,
        days_remaining: (start_date + 1.month - Date.current).to_i
      }
    end

    def calculate_usage_breakdown
      usages = current_enterprise.api_usages.this_month
      {
        api_calls: usages.count,
        successful_calls: usages.successful.count,
        error_calls: usages.errors.count,
        avg_response_time: usages.average(:response_time_ms)&.round(0) || 0
      }
    end

    def calculate_estimated_cost
      usages = current_enterprise.api_usages.this_month
      api_cost = usages.sum(:cost) * 1000 # Convert to KRW

      # Pricing tiers based on plan
      base_price = case @enterprise.plan_type
      when "starter" then 0
      when "growth" then 49000
      when "enterprise" then 490000
      else 0
      end

      overage_cost = calculate_overage_cost(usages.count)

      {
        base_price: base_price,
        api_calls_cost: api_cost.round(0),
        overage_cost: overage_cost,
        total: (base_price + api_cost + overage_cost).round(0)
      }
    end

    def calculate_overage_cost(call_count)
      # Free tier limits
      limits = {
        "starter" => 1000,
        "growth" => 50000,
        "enterprise" => 500000
      }

      limit = limits[@enterprise.plan_type] || 1000
      overage = [ call_count - limit, 0 ].max

      # Overage pricing: 10 KRW per call
      overage * 10
    end

    def generate_billing_history
      # Generate mock billing history for past 6 months
      (1..6).map do |i|
        period_start = (i.months.ago).beginning_of_month
        {
          period: period_start.strftime("%Y년 %m월"),
          start_date: period_start,
          end_date: period_start.end_of_month,
          amount: calculate_historical_amount(i),
          status: i == 1 ? "pending" : "paid",
          invoice_number: "INV-#{period_start.strftime('%Y%m')}-#{@enterprise.id.to_s.rjust(4, '0')}"
        }
      end
    end

    def calculate_historical_amount(months_ago)
      usages = current_enterprise.api_usages
        .where(created_at: months_ago.months.ago.beginning_of_month..months_ago.months.ago.end_of_month)

      base_price = case @enterprise.plan_type
      when "starter" then 0
      when "growth" then 49000
      when "enterprise" then 490000
      else 0
      end

      api_cost = usages.sum(:cost) * 1000
      (base_price + api_cost).round(0)
    end
  end
end
