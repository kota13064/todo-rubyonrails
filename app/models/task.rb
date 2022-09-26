class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_status
  belongs_to :priority

  validates :name, presence: true

  scope :search, lambda { |params|
    params[:per] = params[:per] || 10
    order(created_at: :desc)
      .order_by_column(params[:order_column], params[:order])
      .search_by_name(params[:name])
      .search_by_status(params[:task_status_id])
      .page(params[:page]).per(params[:per])
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

  scope :select_user, lambda { |user_id|
    where(user_id:)
  }
end
