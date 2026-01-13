class AccessToken < ApplicationRecord
  STATUSES = %w[active revoked expired].freeze

  belongs_to :enterprise
  has_many :api_usages, dependent: :nullify

  validates :token_digest, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :name, presence: true, length: { maximum: 100 }

  scope :active, -> { where(status: "active") }
  scope :valid, -> { active.where("expires_at IS NULL OR expires_at > ?", Time.current) }

  attr_accessor :raw_token

  before_validation :generate_token, on: :create

  def self.authenticate(raw_token)
    return nil if raw_token.blank?

    digest = Digest::SHA256.hexdigest(raw_token.to_s)
    token = valid.find_by(token_digest: digest)

    if token
      token.update_columns(
        last_used_at: Time.current,
        usage_count: token.usage_count + 1
      )
    end

    token
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def revoke!
    update!(status: "revoked")
  end

  def status_label
    case status
    when "active" then "활성"
    when "revoked" then "폐기됨"
    when "expired" then "만료됨"
    else status
    end
  end

  private

  def generate_token
    self.raw_token = "ck_#{SecureRandom.urlsafe_base64(32)}"
    self.token_digest = Digest::SHA256.hexdigest(raw_token)
  end
end
