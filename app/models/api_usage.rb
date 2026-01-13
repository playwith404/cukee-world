class ApiUsage < ApplicationRecord
  METHODS = %w[GET POST PUT PATCH DELETE].freeze

  belongs_to :enterprise
  belongs_to :access_token, optional: true

  validates :endpoint, presence: true
  validates :method, presence: true, inclusion: { in: METHODS }
  validates :response_code, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than: 600 }

  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(created_at: 1.week.ago..Time.current) }
  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :successful, -> { where(response_code: 200..299) }
  scope :errors, -> { where(response_code: 400..599) }
  scope :client_errors, -> { where(response_code: 400..499) }
  scope :server_errors, -> { where(response_code: 500..599) }

  def success?
    response_code.between?(200, 299)
  end

  def client_error?
    response_code.between?(400, 499)
  end

  def server_error?
    response_code.between?(500, 599)
  end

  def response_code_label
    case response_code
    when 200 then "OK"
    when 201 then "Created"
    when 400 then "Bad Request"
    when 401 then "Unauthorized"
    when 403 then "Forbidden"
    when 404 then "Not Found"
    when 429 then "Too Many Requests"
    when 500 then "Internal Server Error"
    when 502 then "Bad Gateway"
    when 503 then "Service Unavailable"
    else response_code.to_s
    end
  end
end
