class ApiKey < ApplicationRecord
  ENVIRONMENTS = %w[production staging development].freeze
  STATUSES = %w[active revoked].freeze

  belongs_to :enterprise

  validates :name, presence: true, length: { maximum: 100 }
  validates :key_prefix, presence: true
  validates :key_digest, presence: true, uniqueness: true
  validates :environment, inclusion: { in: ENVIRONMENTS }
  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where(status: "active") }
  scope :production, -> { where(environment: "production") }
  scope :staging, -> { where(environment: "staging") }
  scope :development, -> { where(environment: "development") }

  attr_accessor :raw_key

  before_validation :generate_key, on: :create

  def masked_key
    "#{key_prefix}#{'*' * 20}"
  end

  def revoke!
    update!(status: "revoked")
  end

  def active?
    status == "active"
  end

  def environment_label
    case environment
    when "production" then "프로덕션"
    when "staging" then "스테이징"
    when "development" then "개발"
    else environment
    end
  end

  def status_label
    case status
    when "active" then "활성"
    when "revoked" then "폐기됨"
    else status
    end
  end

  private

  def generate_key
    env_prefix = environment[0]
    self.raw_key = "ck_#{env_prefix}_#{SecureRandom.hex(24)}"
    self.key_prefix = raw_key[0..11]
    self.key_digest = Digest::SHA256.hexdigest(raw_key)
  end
end
