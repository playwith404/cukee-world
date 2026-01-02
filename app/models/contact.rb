class Contact < ApplicationRecord
  INQUIRY_TYPES = %w[general sales support partnership].freeze

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :inquiry_type, inclusion: { in: INQUIRY_TYPES }

  def inquiry_type_label
    case inquiry_type
    when "general" then "일반 문의"
    when "sales" then "영업/구매"
    when "support" then "기술 지원"
    when "partnership" then "파트너십"
    else inquiry_type
    end
  end
end
