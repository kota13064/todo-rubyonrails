class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  scope :default, lambda {
    select('users.*, COUNT(tasks.id) AS count_of_tasks')
      .left_outer_joins(:tasks)
      .group(:id)
      .order(created_at: :desc)
  }

  scope :search, lambda { |params|
    default
      .page(params[:page]).per(params[:per])
  }
end
