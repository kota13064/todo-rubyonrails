class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_status
  belongs_to :priority

  validates :name, presence: true

  scope :default, lambda {
    select('tasks.*, task_statuses.name AS status_name, priorities.name AS priority_name')
      .joins(:task_status)
      .joins(:priority)
      .order(created_at: :desc)
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

  scope :search, lambda { |params|
    default
      .search_by_name(params[:name])
      .search_by_status(params[:task_status_id])
      .order_by_column(params[:order_column], params[:order])
      .page(params[:page]).per(params[:per])
  }
end
