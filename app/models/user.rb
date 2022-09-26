class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  scope :search, lambda { |params|
    order(created_at: :desc)
      .page(params[:page]).per(params[:per])
  }
end
