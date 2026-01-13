module Console
  class ApiUsageController < BaseController
    def index
      @period = params[:period] || "daily"
      @usages = fetch_usages_by_period
      @chart_data = prepare_chart_data
      @endpoint_breakdown = calculate_endpoint_breakdown
      @response_code_breakdown = calculate_response_code_breakdown
    end

    private

    def fetch_usages_by_period
      case @period
      when "daily"
        current_enterprise.api_usages.today
      when "weekly"
        current_enterprise.api_usages.this_week
      when "monthly"
        current_enterprise.api_usages.this_month
      else
        current_enterprise.api_usages.today
      end
    end

    def prepare_chart_data
      case @period
      when "daily"
        hourly_data
      when "weekly"
        daily_data(7)
      when "monthly"
        daily_data(30)
      else
        hourly_data
      end
    end

    def hourly_data
      hours = (0..23).map { |h| format("%02d:00", h) }
      calls = Array.new(24, 0)
      errors = Array.new(24, 0)

      current_enterprise.api_usages.today.each do |usage|
        hour = usage.created_at.hour
        calls[hour] += 1
        errors[hour] += 1 unless usage.success?
      end

      { labels: hours, calls: calls, errors: errors }
    end

    def daily_data(days)
      labels = (0...days).map { |i| (Date.current - i).strftime("%m/%d") }.reverse
      calls = Array.new(days, 0)
      errors = Array.new(days, 0)

      start_date = days.days.ago.beginning_of_day
      current_enterprise.api_usages.where(created_at: start_date..Time.current).each do |usage|
        day_index = (usage.created_at.to_date - start_date.to_date).to_i
        if day_index >= 0 && day_index < days
          calls[day_index] += 1
          errors[day_index] += 1 unless usage.success?
        end
      end

      { labels: labels, calls: calls, errors: errors }
    end

    def calculate_endpoint_breakdown
      @usages.group(:endpoint).count.sort_by { |_, v| -v }
    end

    def calculate_response_code_breakdown
      @usages.group(:response_code).count.sort_by { |_, v| -v }
    end
  end
end
