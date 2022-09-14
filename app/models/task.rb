class Task < ApplicationRecord
  belongs_to :task_status
  belongs_to :priority

  validates :name, presence: true

  scope :default, lambda {
    select('tasks.*, task_statuses.name AS status_name, priorities.name AS priority_name')
      .joins(:task_status)
      .joins(:priority)
      .order(created_at: :desc)
  }

  scope :order_by_column, lambda { |params|
    reorder(params[:order_column] => params[:order]) if params[:order].present? && params[:order_column].present?
  }

  scope :search_by_name, lambda { |params|
    where('tasks.name LIKE ?', "%#{Task.sanitize_sql_like(params[:name])}%") if params[:name].present?
  }

  scope :search_by_status, lambda { |params|
    where(task_status_id: params[:task_status_id]) if params[:task_status_id].present?
  }

  scope :search, lambda { |params|
    default
      .search_by_name(params)
      .search_by_status(params)
      .order_by_column(params)
  }
end
