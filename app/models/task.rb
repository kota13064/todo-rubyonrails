class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_status
  belongs_to :priority
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags, dependent: :nullify

  validates :name, presence: true

  scope :search, lambda { |params|
    params[:per] = params[:per] || 10
    order(created_at: :desc)
      .order_by_column(params[:order_column], params[:order])
      .search_by_name(params[:name])
      .search_by_status(params[:task_status_id])
      .page(params[:page]).per(params[:per])
      .search_by_tag_ids(params[:tag_ids])
  }

  scope :order_by_column, lambda { |order_column, order|
    reorder(order_column => order) if order.present? && order_column.present?
  }

  scope :search_by_name, lambda { |name|
    where('tasks.name LIKE ?', "%#{Task.sanitize_sql_like(name)}%") if name.present?
  }

  scope :search_by_status, lambda { |task_status_id|
    where(task_status_id:) if task_status_id.present?
  }

  scope :search_by_tag_ids, lambda { |tag_ids|
    joins(:task_tags).merge(TaskTag.where(tag_id: tag_ids.compact_blank)).distinct if tag_ids&.compact_blank.present?
  }

  scope :select_user, lambda { |user_id|
    where(user_id:)
  }
end
