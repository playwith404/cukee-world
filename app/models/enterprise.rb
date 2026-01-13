class Enterprise < ApplicationRecord
  PLAN_TYPES = %w[starter growth enterprise].freeze
  STATUSES = %w[active suspended cancelled].freeze

  has_many :access_tokens, dependent: :destroy
  has_many :api_usages, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  has_one :alert_setting, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 200 }
  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :plan_type, inclusion: { in: PLAN_TYPES }
  validates :status, inclusion: { in: STATUSES }

  after_create :create_default_alert_setting

  def plan_type_label
    case plan_type
    when "starter" then "스타터"
    when "growth" then "그로스"
    when "enterprise" then "엔터프라이즈"
    else plan_type
    end
  end

  def status_label
    case status
    when "active" then "활성"
    when "suspended" then "일시정지"
    when "cancelled" then "해지"
    else status
    end
  end

  def usage_percentage
    return 0 if monthly_limit.nil? || monthly_limit.zero?
    ((current_usage / monthly_limit) * 100).round(1)
  end

  def active?
    status == "active"
  end

  private

  def create_default_alert_setting
    create_alert_setting(notification_email: email)
  end
end
